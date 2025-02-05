<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User_Login</title>
    <link rel="stylesheet" href="./CSS/userStyle.css">
    <link rel="stylesheet" href="./Bootstrap/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Nunito:ital,wght@0,200..1000;1,200..1000&display=swap" rel="stylesheet">
</head>
<body>
    <body class="hideScroll">
        <cfoutput>
            <div class="d-flex accessPageHead justify-content-between py-2">
                <div class="ms-5">
                    <i class="fa-brands fa-shopify fs-1 text-dark"></i>
                    <span>SHOPPING CART</span>
                </div>
                <div class="d-flex me-5">
                    <div class="me-4"><a class="accessNames" href="./userSignUp.cfm"><img src=""> Sign Up</a></div>
                    <div><a class="accessNames" href="./userLogin.cfm"><img height="20" src=""> Login</a></div>
                </div>
            </div>
            <div class="row w-100 mainBody">
                <div class="col-4"></div>
                <div class="col-4 mt-5 mb-5 text-center accessMainDiv">
                    <div class="accessHeading">USER LOGIN</div>
                    <form action="" method="POST">
                        <div>
                            <div>
                                <input name="emailId" id="emailIds" class="inputStyle" type="text" placeholder="Enter Email ID or Phone Number">
                                <div id="emailWarning" class="registerWarning"></div>
                            </div>  
                            <div>
                                <input name="password" id="passwordId" class="inputStyle" type="password" placeholder="Enter Password">
                                <div id="passWarning" class="registerWarning"></div>
                            </div>
                            <div>
                                <button name="loginButton" onclick="" type="submit" class="accessButton py-1 mt-3">LOGIN</button>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="col-4"></div>
            </div>
            <cfif structKeyExists(form,"loginButton")>
                <cfset userLoginObject = new Component.userComponent()>
                <cfif structKeyExists(url, "productId") AND structKeyExists(url, "buyNow")>
                    <cfset result = userLoginObject.loginUser(
                        enteredId = form.emailId,
                        enteredPassword = form.password,
                        productId = url.productId,
                        buyNow = true
                    )>
                    <cfelseif structKeyExists(url, "productId")>
                        <cfset result = userLoginObject.loginUser(
                            enteredId = form.emailId,
                            enteredPassword = form.password,
                            productId = url.productId
                        )>
                    <cfelse>
                        <cfset result = userLoginObject.loginUser(
                            enteredId = form.emailId,
                            enteredPassword = form.password
                        )>
                </cfif>
                <div class="text-center">
                    <div class="text-danger fw-bold">#result["message"]#</div>
                </div>
            </cfif>
        </cfoutput>
        <script src="./Script/userPage.js"></script>
    </body>
</html>