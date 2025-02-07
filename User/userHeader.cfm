<cfoutput>
    <div class="userNavBar align-items-center px-3 py-1">
        <div>
            <i class="fa-brands fa-shopify fs-1 text-dark"></i>
            <a href="./userhomePage.cfm" class="navHead">eCart</a>
        </div>
        <cfif structKeyExists(form,"searchButton")>
            <cflocation  url="./subCategoriesListingPage.cfm?searchKeyword=#form.searchKeyword#">
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
            <a href="./userCartPage.cfm" class="mx-3 position-relative">
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
                <a href="./userProfilePage.cfm" class="mx-2">
                    <i class="fa-solid fa-lg fa-user"></i>
                    #session.username#
                </a>
                <button class="logoutButton" onclick="logoutFunction()">
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
                        <h5 class="modal-title" id="staticBackdropLabel">Login User</h5>
                    </div>
                    <div class="modal-body">
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
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary py-2" onclick="closeUserModal()" data-bs-dismiss="modal">Close</button>
                        <button name="loginButton" onclick="loginModal()" type="button" class="accessButton py-2">LOGIN</button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</cfoutput>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>

