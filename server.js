const express = require('express');
const session = require('express-session');
const path = require('path');
const { Pool } = require('pg');
const userRoutes = require('./public/js/userRoutes');

// Set up PostgreSQL connection
const pool = new Pool({
  user: 'postgres',
  host: 'localhost',
  database: 'A5',
  password: 'admin',
  port: 5432,
});

// Import express-handlebars
const { engine } = require('express-handlebars');

const app = express();
const PORT = process.env.PORT || 3000;

// Define the `eq` helper
const hbs = engine({
  helpers: {
    eq: (v1, v2) => v1 === v2,
    // You can define other helpers here as needed
  }
});

// Set up Handlebars
app.engine('handlebars', hbs);
app.set('view engine', 'handlebars');
app.set('views', path.join(__dirname, 'views'));

// Middleware
app.use(express.static(path.join(__dirname, '/public'))); // Static server
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
// After initializing the app
app.use(session({
    secret: 'your_secret_key',
    resave: false,
    saveUninitialized: true,
    cookie: { secure: !true } // Set to true if using https
  }));

// Routes
app.get('/', (req, res) => {
  res.redirect('/register');
});

// Dashboard
app.get('/dashboard', (req, res) => {
  if (req.session.userid) {
      const userid = req.session.userid;

      // Fetching both strength and weight goals in one query for efficiency
      const sqlFitnessGoals = "SELECT * FROM FitnessGoals WHERE MemberID = $1";
      pool.query(sqlFitnessGoals, [userid], (error, resultsFitnessGoals) => {
          if (error) {
              console.error('Error executing fitness goals query', error.stack);
              res.status(500).send("Error retrieving fitness goals");
              return;
          }

          // Query to fetch all health metrics
          const sqlHealthMetrics = "SELECT * FROM HealthMetrics WHERE MemberID = $1";
          pool.query(sqlHealthMetrics, [userid], (error, resultsHealthMetrics) => {
              if (error) {
                  console.error('Error executing health metrics query', error.stack);
                  res.status(500).send("Error retrieving health metrics");
                  return;
              }

              // Query to fetch fitness achievements
              const sqlFitnessAchievements = "SELECT * FROM FitnessAchievements WHERE MemberID = $1";
              pool.query(sqlFitnessAchievements, [userid], (error, resultsFitnessAchievements) => {
                  if (error) {
                      console.error('Error executing fitness achievements query', error.stack);
                      res.status(500).send("Error retrieving fitness achievements");
                      return;
                  }

                  // Pass all fetched data to the dashboard template
                  res.render('dashboard', {
                      layout: false,
                      fitnessGoals: resultsFitnessGoals.rows,
                      healthMetrics: resultsHealthMetrics.rows,
                      fitnessAchievements: resultsFitnessAchievements.rows
                  });
              });
          });
      });
  } else {
      res.redirect('/login');
  }
});

// Register
app.get('/register', (req, res) => {
  res.render('register', { layout: false });
});

// Trainer Reg
app.get('/registerAsTrainer', (req, res) => {
  if (!req.session.userid) {
      return res.redirect('/login');
  }
  res.render('trainerRegistration', { layout: false });
});

app.post('/register', (req, res) => {
  userRoutes.register(req, res, pool);
});

// Login
app.get('/login', (req, res) => {
    res.render('login', { layout: false });
  });
  

app.post('/login', (req, res) => {
    userRoutes.login(req, res, pool);
  });

// Profile page
app.get('/updateProfile', (req, res) => {
    if (req.session.userid) {
      // You might want to pre-fill the form with the user's current information.
      // This requires a database query based on `req.session.userid` to fetch user details.
      res.render('updateProfile', { layout: false });
    } else {
      res.redirect('/login');
    }
  });

app.post('/updateProfile', (req, res) => {
    userRoutes.updateProfile(req, res, pool);
  });

// Set Fitness Goals
app.get('/setFitnessGoals', (req, res) => {
    if (req.session.userid) {
      res.render('setFitnessGoals', { layout: false });
    } else {
      res.redirect('/login');
    }
  });

app.post('/setFitnessGoals', (req, res) => {
    userRoutes.setFitnessGoals(req, res, pool);
  });

// Schedule
app.get('/schedule', async (req, res) => {
  if (!req.session.userid) {
      return res.redirect('/login');
  }

  try {
      const userid = req.session.userid;
      // Check if the user is a trainer
      const isTrainerResult = await pool.query('SELECT * FROM Trainers WHERE MemberID = $1', [userid]);
      const isTrainer = isTrainerResult.rowCount > 0;
      // Fetch user to check if they are an admin
      const userResult = await pool.query('SELECT isAdmin FROM Members WHERE MemberID = $1', [userid]);
      const isAdmin = userResult.rows[0]?.isadmin;

      const { rows: classes } = await pool.query('SELECT * FROM Classes JOIN Trainers ON Classes.TrainerID = Trainers.TrainerID');
      const classesForCalendar = classes.map(cls => {
          const eventStart = new Date(cls.datetime + 'Z').toISOString();
          return {
              title: `${cls.classname} with ${cls.firstname} ${cls.lastname}`,
              start: eventStart,
              roomID: cls.roomid
          };
      });

      res.render('schedule', {
          layout: false,
          classes: JSON.stringify(classesForCalendar),
          isAdmin,
          isTrainer 
      });
  } catch (error) {
      console.error('Error fetching classes for schedule', error);
      res.status(500).send('Error loading schedule page');
  }
});

// Get the Add Class form
app.get('/addClass', async (req, res) => {
  if (!req.session.userid) {
    return res.redirect('/login');
  }
  
  // Check if the user is a trainer
  const trainerCheckResult = await pool.query('SELECT * FROM Trainers WHERE MemberID = $1', [req.session.userid]);
  if (trainerCheckResult.rowCount === 0) {
    return res.status(403).send("You must be a trainer to access this page.");
  }

  res.render('addClass', { layout: false });
});

// Process the Add Class form
app.post('/addClass', async (req, res) => {
  if (!req.session.userid) {
    return res.status(401).send("Not authorized");
  }

  const userid = req.session.userid;
  const { classname, roomID, date, time, groupSession } = req.body;
  const datetime = `${date} ${time}:00`;
  const isGroupSession = groupSession ? true : false;

  try {
    // Check if the user is a trainer
    const trainerResult = await pool.query('SELECT TrainerID FROM Trainers WHERE MemberID = $1', [userid]);
    if (trainerResult.rowCount === 0) {
      return res.status(403).send("You must be a trainer to perform this action.");
    }

    const trainerID = trainerResult.rows[0].trainerid;

    // Check if the room is already booked for the specified datetime
    const roomBookedResult = await pool.query('SELECT * FROM Classes WHERE RoomID = $1 AND DateTime = $2', [roomID, datetime]);
    if (roomBookedResult.rowCount > 0) {
      // If the room is already booked, send an error message
      return res.status(409).send("This room is already booked for the selected date and time.");
    }

    // If the room is not booked, proceed to insert the new class
    await pool.query('INSERT INTO Classes (ClassName, RoomID, TrainerID, DateTime, GroupSession) VALUES ($1, $2, $3, $4, $5)', [classname, roomID, trainerID, datetime, isGroupSession]);

    // After successfully adding the class, add an equipment check entry
    await pool.query('INSERT INTO Equipment (RoomID, TrainerID, LastChecked) VALUES ($1, $2, $3)', [roomID, trainerID, date]);

    res.redirect('/schedule');
  } catch (error) {
    console.error('Error while adding class and updating equipment', error);
    res.status(500).send("Error adding class and updating equipment");
  }
});

// Set health metrics
app.get('/setHealthMetrics', (req, res) => {
  if (req.session.userid) {
    res.render('setHealthMetrics', { layout: false });
  } else {
    res.redirect('/login');
  }
});

app.post('/setHealthMetrics', (req, res) => {
    userRoutes.setHealthMetrics(req, res, pool);
  });


// Update Fitness Goal
app.post('/updateFitnessGoal', async (req, res) => {
  if (!req.session.userid) {
    return res.status(401).send("Not authorized");
  }

  const userid = req.session.userid;
  const { id, type, newValue } = req.body; // Assuming type can be 'currentstrengthweight', 'goalstrengthweight', 'currentweight', or 'desiredweight'
  let columnToUpdate = type;
  let goalType;

  if (type.includes('strength')) {
    goalType = 'Strength';
  } else if (type.includes('weight')) {
    goalType = 'Weight';
  }

  try {
    // First, update the fitness goal
    const updateResult = await pool.query(`UPDATE FitnessGoals SET "${columnToUpdate}" = $1 WHERE GoalID = $2 AND MemberID = $3 RETURNING *`, [newValue, id, userid]);
    const goal = updateResult.rows[0];

    // Check if the goal is achieved
    if ((goalType === 'Strength' && goal.currentstrengthweight >= goal.goalstrengthweight) ||
        (goalType === 'Weight' && goal.currentweight >= goal.desiredweight)) {
      
      // Record the achievement
      const insertAchievementSql = `
        INSERT INTO FitnessAchievements (MemberID, AchievementType, AchievementValue, ExerciseType, AchievementDate)
        VALUES ($1, $2, $3, $4, NOW())`;

      await pool.query(insertAchievementSql, [userid, goalType, newValue, goal.exercisetype]);

      // Remove duplicate achievements
      await pool.query(`
        DELETE FROM FitnessAchievements
        WHERE ctid NOT IN (
          SELECT min(ctid)
          FROM FitnessAchievements
          GROUP BY MemberID, AchievementType, AchievementValue, ExerciseType, AchievementDate
        ) AND MemberID = $1`, [userid]);

      res.send("Fitness goal updated successfully, achievement recorded.");
    } else {
      res.send("Fitness goal updated successfully");
    }
  } catch (error) {
    console.error('Error updating fitness goal or recording achievement', error.stack);
    res.status(500).send("Error updating fitness goal or recording achievement");
  }
});

// Update Health Metric
app.post('/updateHealthMetric', (req, res) => {
  if (!req.session.userid) {
      return res.status(401).send("Not authorized");
  }

  const { id, type, newValue } = req.body;
  if(type !== 'metricvalue') {
      return res.status(400).send("Invalid update type for health metric");
  }

  const sql = `UPDATE HealthMetrics SET MetricValue = $1 WHERE MetricID = $2 AND MemberID = $3`;
  pool.query(sql, [newValue, id, req.session.userid], (error) => {
      if (error) {
          console.error('Error updating health metric', error.stack);
          res.status(500).send("Error updating health metric");
      } else {
          res.send("Health metric updated successfully");
      }
  });
});

// Delete a fitness goal
app.post('/deleteFitnessGoal', (req, res) => {
  if (!req.session.userid) {
      return res.status(401).send("Not authorized");
  }

  const { id } = req.body; // Assuming you're sending the goal ID as 'id'
  const userid = req.session.userid;

  const sql = "DELETE FROM FitnessGoals WHERE GoalID = $1 AND MemberID = $2";
  pool.query(sql, [id, userid], (error) => {
      if (error) {
          console.error('Error deleting fitness goal', error.stack);
          res.status(500).send("Error deleting fitness goal");
      } else {
          res.send("Fitness goal deleted successfully");
      }
  });
});

// Delete a health metric
app.post('/deleteHealthMetric', (req, res) => {
  if (!req.session.userid) {
      return res.status(401).send("Not authorized");
  }

  const { id } = req.body; // Assuming you're sending the metric ID as 'id'
  const userid = req.session.userid;

  const sql = "DELETE FROM HealthMetrics WHERE MetricID = $1 AND MemberID = $2";
  pool.query(sql, [id, userid], (error) => {
      if (error) {
          console.error('Error deleting health metric', error.stack);
          res.status(500).send("Error deleting health metric");
      } else {
          res.send("Health metric deleted successfully");
      }
  });
});

// Trainer Reg Processing
app.post('/registerAsTrainer', async (req, res) => {
  if (!req.session.userid) {
    return res.status(401).send("Not authorized");
  }

  const userid = req.session.userid;
  const { specialization, className, roomID, availabilityDate, availabilityTime, groupSession } = req.body;
  const datetime = `${availabilityDate} ${availabilityTime}:00`;
  const isGroupSession = groupSession ? true : false;

  try {
    // Insert new trainer with MemberID
    const insertTrainerSql = `
      INSERT INTO Trainers (FirstName, LastName, Specialization, MemberID) 
      SELECT FirstName, LastName, $1, $2 FROM Members WHERE MemberID = $2
      RETURNING TrainerID`;

    const trainerResult = await pool.query(insertTrainerSql, [specialization, userid]);

    if (trainerResult.rows.length === 0) {
      throw new Error('Trainer registration failed.');
    }

    const trainerID = trainerResult.rows[0].trainerid;

    // Insert into Classes table with the TrainerID
    const insertClassSql = `
      INSERT INTO Classes (ClassName, RoomID, TrainerID, DateTime, GroupSession) 
      VALUES ($1, $2, $3, $4, $5)`;

    await pool.query(insertClassSql, [className, roomID, trainerID, datetime, isGroupSession]);

    res.send("Registered as trainer and class created successfully!");
  } catch (error) {
    console.error('Error in trainer registration process', error);
    res.status(500).send("Error registering as trainer");
  }
});

// Get the Member Lookup form
app.get('/memberLookup', async (req, res) => {
  if (!req.session.userid) {
    return res.redirect('/login');
  }
  
  // Check if the user is a trainer
  const trainerCheckResult = await pool.query('SELECT * FROM Trainers WHERE MemberID = $1', [req.session.userid]);
  if (trainerCheckResult.rowCount === 0) {
    return res.status(403).send("You must be a trainer to access this page.");
  }

  res.render('memberLookup', { layout: false, isTrainer: true });
});

// Process the Member Lookup form
app.post('/performMemberLookup', async (req, res) => {
  if (!req.session.userid) {
    return res.status(401).send("Not authorized");
  }
  
  const { searchQuery } = req.body;
  let member;

  try {
    // Check if searchQuery is a member ID
    if (!isNaN(searchQuery)) {
      member = await pool.query('SELECT * FROM Members WHERE MemberID = $1', [searchQuery]);
    } else {
      // Assume the searchQuery is "firstname lastname"
      const [firstname, lastname] = searchQuery.split(' ');
      member = await pool.query('SELECT * FROM Members WHERE FirstName = $1 AND LastName = $2', [firstname, lastname]);
    }

    if (member.rowCount === 0) {
      return res.status(404).send("Member not found.");
    }

    // Redirect to the member's dashboard
    const memberID = member.rows[0].memberid;
    req.session.viewedMemberID = memberID; // Temporarily store this for viewing their dashboard
    res.redirect('/viewMemberDashboard'); // A route you'll create for viewing another member's dashboard
  } catch (error) {
    console.error('Error performing member lookup', error);
    res.status(500).send("Error performing lookup");
  }
});

// View a member's dashboard as a trainer
app.get('/viewMemberDashboard', async (req, res) => {
  if (!req.session.userid || !req.session.viewedMemberID) {
    return res.status(401).send("Not authorized");
  }

  // Check if the user is a trainer and has permissions to view other dashboards
  const isTrainer = await pool.query('SELECT * FROM Trainers WHERE MemberID = $1', [req.session.userid]);
  if (isTrainer.rowCount === 0) {
    return res.status(403).send("Only trainers can access this page.");
  }

  // Fetch the data for the member's dashboard
  const memberID = req.session.viewedMemberID;

  try {
    const resultsFitnessGoals = await pool.query('SELECT * FROM FitnessGoals WHERE MemberID = $1', [memberID]);
    const resultsHealthMetrics = await pool.query('SELECT * FROM HealthMetrics WHERE MemberID = $1', [memberID]);
    const resultsFitnessAchievements = await pool.query('SELECT * FROM FitnessAchievements WHERE MemberID = $1', [memberID]);

    // Render the member's dashboard
    res.render('dashboard', {
      layout: false,
      fitnessGoals: resultsFitnessGoals.rows,
      healthMetrics: resultsHealthMetrics.rows,
      fitnessAchievements: resultsFitnessAchievements.rows,
      isTrainerViewing: true // You can use this to customize the dashboard for trainers
    });
  } catch (error) {
    console.error('Error fetching data for member dashboard', error);
    res.status(500).send("Error loading member's dashboard");
  }
});

// Route to display class registration page
app.get('/classRegistration', async (req, res) => {
  if (!req.session.userid) {
    return res.redirect('/login');
  }

  try {
    const { rows: classes } = await pool.query('SELECT * FROM Classes');
    res.render('classRegistration', {
      layout: false,
      classes: classes // Passing the classes to the template
    });
  } catch (error) {
    console.error('Error fetching classes', error);
    res.status(500).send('Error loading class registration page');
  }
});

// Route to process class registration
app.post('/registerForClass', async (req, res) => {
  if (!req.session.userid) {
      return res.status(401).send("Not authorized");
  }

  const memberId = req.session.userid;
  const { classId, cardNumber } = req.body; // Assuming you've added an input for cardNumber in your form

  try {
      await pool.query('INSERT INTO ClassRegistrations (MemberID, ClassID) VALUES ($1, $2)', [memberId, classId]);

      // Simulate a billing amount for the sake of the example
      const amount = 50; // Let's say each class costs $50

      // Insert into billing table
      await pool.query('INSERT INTO Billing (MemberID, Amount, CardNumber, BillDate) VALUES ($1, $2, $3, NOW())', [memberId, amount, cardNumber]);

      res.redirect('/schedule');
  } catch (error) {
      console.error('Error registering for class or processing billing', error);
      res.status(500).send('Error processing class registration and billing');
  }
});

// Route to display the Admin Panel
app.get('/admin', async (req, res) => {
  if (!req.session.userid || !req.session.isAdmin) {
    return res.status(401).send("Not authorized or not an admin");
  }

  try {
    const classes = await pool.query('SELECT * FROM Classes');
    const equipment = await pool.query('SELECT * FROM Equipment');
    res.render('admin', {
      layout: false,
      classes: classes.rows,
      equipment: equipment.rows
    });
  } catch (error) {
    console.error('Error fetching data for admin panel', error);
    res.status(500).send('Error loading admin panel');
  }
});

app.get('/fetchRegisteredClasses', async (req, res) => {
  if (!req.session.userid) {
    return res.status(401).send("Not authorized");
  }

  try {
    const registeredClasses = await pool.query(
      `SELECT ClassRegistrations.RegistrationID, Classes.ClassName, Classes.DateTime
      FROM ClassRegistrations
      JOIN Classes ON ClassRegistrations.ClassID = Classes.ClassID
      WHERE ClassRegistrations.MemberID = $1`,
      [req.session.userid]
    );
    res.json(registeredClasses.rows);
  } catch (error) {
    console.error('Error fetching registered classes', error);
    res.status(500).send('Error fetching registered classes');
  }
});

app.post('/cancelClassRegistration', async (req, res) => {
  if (!req.session.userid) {
    return res.status(401).send("Not authorized");
  }

  const { registrationId } = req.body; // You will send the registrationId when submitting the form

  try {
    await pool.query(
      'DELETE FROM ClassRegistrations WHERE RegistrationID = $1 AND MemberID = $2',
      [registrationId, req.session.userid]
    );
    res.send("Class registration cancelled successfully.");
  } catch (error) {
    console.error('Error cancelling class registration', error);
    res.status(500).send('Error cancelling class registration');
  }
});

app.get('/cancelClass', async (req, res) => {
  if (!req.session.userid) {
    return res.redirect('/login');
  }

  try {
    // Check if the user is a trainer
    const trainerResult = await pool.query('SELECT TrainerID FROM Trainers WHERE MemberID = $1', [req.session.userid]);
    if (trainerResult.rowCount === 0) {
      return res.status(403).send("You must be a trainer to access this page.");
    }
    const trainerID = trainerResult.rows[0].trainerid;

    // Fetch classes booked by the trainer
    const { rows: classes } = await pool.query('SELECT * FROM Classes WHERE TrainerID = $1', [trainerID]);

    res.render('cancelClass', {
      layout: false,
      classes: classes // Passing the classes to the template
    });
  } catch (error) {
    console.error('Error fetching classes for cancellation', error);
    res.status(500).send('Error loading cancel class page');
  }
});

app.post('/cancelClass', async (req, res) => {
  if (!req.session.userid) {
    return res.status(401).send("Not authorized");
  }

  const { classId } = req.body;
  const userid = req.session.userid;

  try {
    // Check if the user is a trainer
    const trainerResult = await pool.query('SELECT TrainerID FROM Trainers WHERE MemberID = $1', [userid]);
    if (trainerResult.rowCount === 0) {
      return res.status(403).send("You must be a trainer to perform this action.");
    }
    const trainerID = trainerResult.rows[0].trainerid;

    // Cancel the class
    await pool.query('DELETE FROM Classes WHERE ClassID = $1 AND TrainerID = $2', [classId, trainerID]);

    // Optionally, add logic to handle related deletions or notifications

    res.redirect('/schedule');
  } catch (error) {
    console.error('Error cancelling class', error);
    res.status(500).send('Error processing class cancellation - Students enrolled in class.');
  }
});

app.post('/deleteClass', async (req, res) => {
  if (!req.session.userid || !req.session.isAdmin) {
    return res.status(401).send("Not authorized or not an admin");
  }

  const { classId } = req.body;

  try {
    await pool.query('DELETE FROM Classes WHERE ClassID = $1', [classId]);

    // Optionally, add logic here to handle any cascading deletions or cleanups as needed.
    
    res.redirect('/admin');
  } catch (error) {
    console.error('Error deleting class', error);
    res.status(500).send('Error deleting class');
  }
});

// Start server
app.listen(PORT, err => {
  if (err) console.log(err);
  else {
    console.log(`Server listening on port: ${PORT}`);
    console.log(`Navigate to:`);
    console.log(`http://localhost:${PORT}/register`);
  }
});