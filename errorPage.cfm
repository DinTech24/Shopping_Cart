<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/x-icon" href="../Assets/SiteImages/LogoImage.png">
    <title>ERROR PAGE</title>
    <link rel="stylesheet" href="./Admin/Bootstrap/bootstrap.min.css"/>
</head>
<body>
    <cfoutput>
        <div class="text-center mx-auto mt-5">
            <img src="../Assets/SiteImages/error.jpg" height="300">
            <div class="fs-1 fw-bold">ERROR OCCURED</div>
            <cfset structClear(session)>
            <cfif structKeyExists(url,"admin")>
                <a href="./Admin/adminLoginpage.cfm" class="fw-bold">Back to Login Page</a>
            <cfelse>
                <a href="./User/userhomePage.cfm" class="fw-bold">Back to Home Page</a>
            </cfif>
        </div>
    </cfoutput>
</body>
</html>