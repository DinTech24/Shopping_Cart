<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>User Home Page</title>
        <link rel="stylesheet" href="./CSS/userStyle.css">
        <link rel="stylesheet" href="./Bootstrap/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    </head>
    <body>
        <cfoutput>
            <div class="modal fade" id="staticBackdropAddress" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <form method="POST" id="userAddressForm">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="staticBackdropLabel">Add Address</h5>
                            </div>
                            <div class="modal-body">
                                <div>
                                    <div class="addressLabel">Enter person's First Name</div>
                                    <input name="emailId" id="emailIds" class="inputStyleNew" type="text">
                                    <div id="emailWarning" class="registerWarning"></div>
                                </div>
                                <div>
                                    <div class="addressLabel">Enter person's Last Name</div>
                                    <input name="emailId" id="emailIds" class="inputStyleNew" type="text">
                                    <div id="emailWarning" class="registerWarning"></div>
                                </div>
                                <div>
                                    <div class="addressLabel">Address Line 1</div>
                                    <input name="emailId" id="emailIds" class="inputStyleNew" type="text">
                                    <div id="emailWarning" class="registerWarning"></div>
                                </div>
                                <div>
                                    <div class="addressLabel">Address Line 2</div>
                                    <input name="emailId" id="emailIds" class="inputStyleNew" type="text">
                                    <div id="emailWarning" class="registerWarning"></div>
                                </div>
                                <div>
                                    <div class="addressLabel">City</div>
                                    <input name="emailId" id="emailIds" class="inputStyleNew" type="text">
                                    <div id="emailWarning" class="registerWarning"></div>
                                </div>
                                <div>
                                    <div class="addressLabel">State</div>
                                    <input name="emailId" id="emailIds" class="inputStyleNew" type="text">
                                    <div id="emailWarning" class="registerWarning"></div>
                                </div>
                                <div>
                                    <div class="addressLabel">Pincode</div>
                                    <input name="emailId" id="emailIds" class="inputStyleNew" type="text">
                                    <div id="emailWarning" class="registerWarning"></div>
                                </div>
                                <div>
                                    <div class="addressLabel">Phone</div>
                                    <input name="emailId" id="emailIds" class="inputStyleNew" type="text">
                                    <div id="emailWarning" class="registerWarning"></div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary py-2" onclick="closeUserModal()" data-bs-dismiss="modal">Close</button>
                                <button name="addressButton" onclick="addressModal()" type="button" class="accessButton py-2">Add</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <cfset userProfileObject = new Component.userComponent()>
            <cfset userResult = userProfileObject.isUserExist(userId = session.userId)>
            <cfset userAddressResult = userProfileObject.getSavedAddress()>
            <cfinclude  template="./userHeader.cfm">
            <div class="d-flex justify-content-center">
                <img src="../Assets/SiteImages/userProfile.png" class="userProfileLogo my-2">
            </div>
            <div class="d-flex justify-content-center">
                <div class="text-start ms-3 userDataDiv">
                    <div>#userResult.fldFirstName &" "& userResult.fldLastName#</div>
                    <div>#userResult.fldEmail#</div>
                    <div>#userResult.fldPhone#</div>
                    <button class="w-100 btn btn-success">Edit Profile</button>
                </div>
            </div>
            <div class="d-flex justify-content-between mt-5 mx-3">
                <div class="fs-2">Saved Adresses</div>
                <button class="btn btn-primary"  data-bs-toggle="modal" data-bs-target="##staticBackdropAddress">Add new address +</button>
            </div>
            <div class="addressesDiv">
                <cfloop query="userAddressResult">
                    <div class="card addressCard m-3">
                        <ul class="list-group list-group-flush">
                            <li class="list-group-item">Name : #userAddressResult.fldFirstName & userAddressResult.fldLastName#</li>
                            <li class="list-group-item">Line 1 : #userAddressResult.fldAddressLine1 #</li>
                            <li class="list-group-item">Line 2 : #userAddressResult.fldAddressLine2#</li>
                            <li class="list-group-item">City : #userAddressResult.fldCity#</li>
                            <li class="list-group-item">State : #userAddressResult.fldState#</li>
                            <li class="list-group-item">Pincode : #userAddressResult.fldPincode#</li>
                            <li class="list-group-item">Phone : #userAddressResult.fldPhoneNumber#</li>
                        </ul>
                    </div>
                </cfloop>
            </div>
            <cfinclude  template="./footer.cfm">
        </cfoutput>
        <script src="./Script/userPage.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    </body>
</html>