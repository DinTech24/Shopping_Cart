<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Login</title>
        <link rel="stylesheet" href="./CSS/adminStyle.css">
        <link rel="stylesheet" href="./Bootstrap/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    </head>
    <body>
        <cfoutput>
            <cfset variables.adminLoginObject = new Component.adminComponent()>
            <div class="adminNavBar align-items-center px-3 py-2">
                <div>
                    <span class="navHead">ShoppingCart</span>
                </div>
            </div>
            <div class="loginMainDiv mx-auto">
                <div class="adminLoginHead">Admin Login</div>
                <form method="POST">
                    <div>
                        <input name="adminUser" class="my-2 adminLoginInput" type="text" id="adminUsername" placeholder="Enter your EmailId or Phone Number">
                        <div class="warning" id="userWarning"></div>
                        <input name="adminPass" class="my-2 adminLoginInput" type="password" id="adminPassword" placeholder="Enter your password">
                        <div class="warning" id="passwordWarning"></div>
                        <button type="submit" name="adminLoginButton" class="mt-2 adminLoginButton" onclick="adminLogin()">Login</button>
                    </div>
                </form>
            </div>
            <div>
                <cfif structKeyExists(form,"adminLoginButton")>
                    <cfset variables.adminLoginResult = variables.adminLoginObject.adminLogin(form.adminUser,form.adminPass)>
                    <div class="text-danger text-center fw-bold">#variables.adminLoginResult["exception"]#</div>
                </cfif>
            </div>
        </cfoutput>
        <script src="./Script/adminPage.js"></script>
    </body>
</html>