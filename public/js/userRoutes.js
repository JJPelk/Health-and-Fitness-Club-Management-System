
exports.register = function(request, response, pool) {
  const { firstname, lastname, email, password, dateofbirth } = request.body;

  const sql = "INSERT INTO Members (FirstName, LastName, Email, Password, DateOfBirth) VALUES ($1, $2, $3, $4, $5)";
  pool.query(sql, [firstname, lastname, email, password, dateofbirth], (error, results) => {
    if (error) {
      console.error('Error executing query', error.stack);
      response.status(500).send("Error registering new user");
    } else {
      response.redirect('/register');
    }
  });
};

exports.login = async function(request, response, pool) {
  const { email, password } = request.body;
  try {
    const results = await pool.query("SELECT * FROM Members WHERE Email = $1 AND Password = $2", [email, password]);
    if (results.rows.length > 0) {
      const user = results.rows[0];
      request.session.userid = user.memberid;
      request.session.isAdmin = user.isadmin;
      response.redirect('/dashboard');
    } else {
      response.status(401).send("Invalid email or password");
    }
  } catch (error) {
    console.error('Error executing login query', error.stack);
    response.status(500).send("Error logging in");
  }
};
exports.updateProfile = function(request, response, pool) {
  if (!request.session.userid) {
    return response.status(401).send("Session expired or not logged in");
  }
  
  const { firstname, lastname, email, password, dateofbirth } = request.body;
  const userid = request.session.userid;

  const sql = "UPDATE Members SET FirstName = $1, LastName = $2, Email = $3, Password = $4, DateOfBirth = $5 WHERE MemberID = $6";
  pool.query(sql, [firstname, lastname, email, password, dateofbirth, userid], (error, results) => {
    if (error) {
      console.error('Error executing query', error.stack);
      response.status(500).send("Error updating profile");
    } else {
      // Response with HTML content
      response.send(`
        <p>Profile updated successfully.</p>
        <p><a href="/dashboard">Return to Dashboard</a></p>
      `);
    }
  });
};

exports.setFitnessGoals = function(request, response, pool) {
  if (!request.session.userid) {
    return response.status(401).send("Session expired or not logged in");
  }

  const userid = request.session.userid;
  const { goalType, exerciseType, currentStrengthWeight, goalStrengthWeight, currentWeight, desiredWeight } = request.body;

  let sql = '';
  let params = [];

  if (goalType === 'Strength') {
    sql = "INSERT INTO FitnessGoals (MemberID, GoalType, ExerciseType, CurrentStrengthWeight, GoalStrengthWeight) VALUES ($1, $2, $3, $4, $5)";
    params = [userid, goalType, exerciseType, currentStrengthWeight, goalStrengthWeight];
  } else if (goalType === 'Weight') {
    sql = "INSERT INTO FitnessGoals (MemberID, GoalType, CurrentWeight, DesiredWeight) VALUES ($1, $2, $3, $4)";
    params = [userid, goalType, currentWeight, desiredWeight];
  }

  pool.query(sql, params, (error, results) => {
    if (error) {
      console.error('Error executing query', error.stack);
      response.status(500).send("Error setting fitness goal");
    } else {
      // Send back HTML with a link to the dashboard
      response.send(`
          <!DOCTYPE html>
          <html>
          <head>
              <title>Fitness Goal Set</title>
              <link rel="stylesheet" href="/styles/styles.css">
          </head>
          <body>
              <p>Fitness goal set successfully!</p>
              <p><a href="/dashboard">Back to Dashboard</a></p>
          </body>
          </html>
      `);
  }
});
};

exports.setHealthMetrics = function(request, response, pool) {
  if (!request.session.userid) {
      return response.status(401).send("Session expired or not logged in");
  }

  const userid = request.session.userid;
  const { metricType, metricValue, dateRecorded } = request.body;

  const sql = "INSERT INTO HealthMetrics (MemberID, MetricType, MetricValue, DateRecorded) VALUES ($1, $2, $3, $4)";
  pool.query(sql, [userid, metricType, metricValue, dateRecorded], (error, results) => {
      if (error) {
          console.error('Error executing query', error.stack);
          response.status(500).send("Error setting health metric");
      } else {
          response.send(`
              <!DOCTYPE html>
              <html>
              <head>
                  <title>Health Metric Set</title>
                  <link rel="stylesheet" href="/styles/styles.css">
              </head>
              <body>
                  <p>Health metric set successfully!</p>
                  <p><a href="/dashboard">Back to Dashboard</a></p>
              </body>
              </html>
          `);
      }
  });
};



