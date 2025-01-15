<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User_SignUp</title>
    <link rel="stylesheet" href="./CSS/userStyle.css">
    <link rel="stylesheet" href="./Bootstrap/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
    <body>
        <cfoutput>
            <div class="d-flex accessPageHead justify-content-between py-2">
                <div class="ms-5">
                    <img width="30" src="" alt="logo">
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
                    <div class="accessHeading">SIGN UP</div>
                    <form action="" method="POST">
                        <div>
                            <div>
                                <input name="firstName" id="firstNameId" class="inputStyle" type="text" placeholder="Enter First Name">
                                <div id="nameWarning" class="registerWarning"></div>
                            </div>
                            <div>
                                <input name="lastName" id="lastNameId" class="inputStyle" type="text" placeholder="Enter Last Name">
                            </div>
                            <div>
                                <input name="phonenumber" id="phoneId" class="inputStyle" type="texts" placeholder="Enter Phone Number">
                                <div id="phoneWarning" class="registerWarning"></div>
                            </div>
                            <div>
                                <input name="emailId" id="emailIds" class="inputStyle" type="email" placeholder="Enter Email ID">
                                <div id="emailWarning" class="registerWarning"></div>
                            </div>
                            <div>
                                <input name="password" id="passwordId" class="inputStyle" type="password" placeholder="Enter Password">
                                <div id="passWarning" class="registerWarning"></div>
                            </div>
                            <div>
                                <input name="rePassword" id="rePasswordId" class="inputStyle confirmPassword" type="password" placeholder="Confirm Password">
                                <div id="repassWarning" class="registerWarning"></div>
                            </div>
                            <div>
                                <button name="signUpButton" onclick="return registerUser()" type="submit" class="accessButton py-1 mt-3">REGISTER</button>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="col-4"></div>
            </div>
            <cfif structKeyExists(form,"signUpButton")>
                <cfset userRegisterObject = new Component.userComponent()>
                <cfset result = userRegisterObject.addUser(registerStructure = form)>
                <cfif result EQ true>
                    <div class="text-center">
                        <div class="text-success fw-bold">User Registered Successfully<div>
                    <div>
                    <cfelse>
                        <div class="text-center">
                            <div class="text-danger fw-bold">PhoneNumber or email already exists<div>
                        <div>
                </cfif>
            </cfif>
        </cfoutput>
    <script src="./Script/userPage.js"></script>
    </body>
</html>