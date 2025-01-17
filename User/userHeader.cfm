<cfoutput>
    <div class="userNavBar px-3 py-2">
        <div>
            <div class="navHead">ShoppingCart</div>
        </div>
        <div class="d-flex">
            <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
            <button class="btn btn-outline-dark me-3" type="submit">Search</button>
        </div>
        <div clas="d-flex">
            <a href="" class="mx-2">
                <i class="fa-solid fa-lg fa-cart-shopping"></i>
            </a>
            <cfif structKeyExists(session, "userLogin") AND structKeyExists(session, "username")>
                <a href="" class="mx-2">
                    <i class="fa-solid fa-lg fa-user"></i>
                </a>
                <button class="logoutButton" onclick="logoutFunction()">Logout</button>
                <cfelse>
                    <button class="mx-2 LoginButton px-3 py-1" onclick="modalClear()"  data-bs-toggle="modal" data-bs-target="##staticBackdropLogin">Login</button>
            </cfif>
        </div>
    </div>
</cfoutput>

