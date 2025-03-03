<cfoutput>
    <div class="userNavBar align-items-center px-3 py-1">
        <div>
            <img src="../Assets/SiteImages/LogoImage.png" height="50">
            <a href="./userhomePage.cfm" class="navHead">eCart</a>
        </div>
        <cfif structKeyExists(form,"searchButton")>
            <cflocation  url="./subCategoriesListingPage.cfm?searchKeyword=#form.searchKeyword#" addToken="no">
        </cfif>
        <form method="POST">
            <div class="d-flex">
                <input class="form-control me-2" id="searchInput" name="searchKeyword" type="search" placeholder="Search" aria-label="Search">
                <button class="btn btn-outline-dark me-3" onclick="return searchValidate()" name="searchButton" type="submit">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </button>
            </div>
        </form>
        <div clas="d-flex">
            <a href="./userCartPage.cfm" class="mx-3 position-relative" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Go to carts">
                <i class="fa-solid fa-lg fa-cart-shopping"></i>
                <cfif structKeyExists(session, "userLogin") AND structKeyExists(session, "username")>
                    <span id="productQuantityId" class="position-absolute mt-1 start-100 translate-middle badge rounded-circle bg-danger">
                    <cfif session.productQuantity  GT 99>
                        99+
                        <cfelse>
                            #session.productQuantity# 
                    </cfif>
                    </span>
                </cfif>
            </a>
            <cfif structKeyExists(session, "userLogin") AND structKeyExists(session, "username")>
                <a href="./userProfilePage.cfm" class="mx-2"  data-bs-toggle="tooltip" data-bs-placement="bottom" title="Go to profile">
                    <i class="fa-solid fa-lg fa-user"></i>
                    <span class="m-0 text-success">#session.username#</span>
                </a>
                <button class="logoutButton"  data-bs-toggle="modal" data-bs-target="##staticBackdropLogin">
                    Logout
                    <i class="fa-solid fa-right-from-bracket"></i>    
                </button>
                <cfelse>
                    <button class="mx-2 LoginButton px-3 py-1" onclick="modalClear()"  data-bs-toggle="modal" data-bs-target="##staticBackdropLogin">Login</button>
            </cfif>
        </div>
    </div>
    <div class="modal fade" id="staticBackdropLogin" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
        <form method="POST" id="userLoginForm">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="staticBackdropLabel">
                            <cfif structKeyExists(session, "userLogin") AND structKeyExists(session, "username")>
                                Logout User
                                <cfelse>
                                Login User
                            </cfif>
                        </h5>
                    </div>
                    <div class="modal-body">
                        <cfif structKeyExists(session, "userLogin") AND structKeyExists(session, "username")>
                            <h3>Are you sure to logout?</h3>
                            <cfelse>
                                <div>
                                    <div>Enter your EmailId/Phone Number</div>
                                    <input name="emailId" id="emailIds" class="inputStyle" type="text" placeholder="Enter Email ID or Phone Number">
                                    <div id="emailWarning" class="registerWarning"></div>
                                </div>
                                <div>
                                    <div class="mt-3">Enter your Password</div>
                                    <input name="password" id="passwordId" class="inputStyle " type="password" placeholder="Enter Password">
                                    <div id="passWarning" class="registerWarning"></div>
                                </div>
                                <div class="mt-3 createAccount">Don't have an account?<a href="./userSignUp.cfm">create one</a></div>
                        </cfif>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary py-2" onclick="closeUserModal()" data-bs-dismiss="modal">Close</button>
                        <cfif structKeyExists(session, "userLogin") AND structKeyExists(session, "username")>
                            <button name="loginButton" onclick="logoutFunction()" type="button" class="logoutModalButton py-2">LOGOUT</button>
                            <cfelse>
                                <button name="loginButton" onclick="loginModal()" type="button" class="accessButton py-2">LOGIN</button>
                        </cfif>
                    </div>
                </div>
            </div>
        </form>
    </div>
</cfoutput>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

