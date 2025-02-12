<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin_Page</title>
        <link rel="stylesheet" href="./CSS/adminStyle.css">
        <link rel="stylesheet" href="./Bootstrap/bootstrap.min.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    </head>
    <body>
        <cfoutput>
            <cfset variables.adminHomeObject = new Component.adminComponent()>
            <!--- Modal --->
            <div class="modal fade" id="staticBackdrop" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <form method="POST" id="adminProductForm">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="staticBackdropLabel"></h5>
                            </div>
                            <div class="modal-body">
                                <input type="text" class="form-control border-dark" id="categoryId" name="category" placeholder="Enter new category name">
                                <div class="warning" id="addcategoryWarning"></div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" onclick="closeAdminModal()" data-bs-dismiss="modal">Close</button>
                                <button type="button" id="categorySubmitButton" onclick="categoryValidation()" class="btn btn-primary">Submit</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="adminNavBar d-flex justify-content-between align-items-center p-3 mb-3">
                <div>
                    <span>ShoppingCart</span>
                    <span>ADMIN</span>
                </div>
                <div>
                    <a href="../User/userhomePage.cfm" class="btn btn-secondary">Go to User Page</a>
                    <button onclick="logout()" class="btn btn-danger">Logout</button>
                </div>
            </div>
            <div class="adminMainDiv w-100 ">
                <div class="categoriesDivision  mx-auto">
                    <div class="my-2">
                        <span>Categories</span>
                        <button class="categoriesAdd" data-bs-toggle="modal" onclick="createCategory()" data-bs-target="##staticBackdrop">Add +</button>
                    </div>
                    <div>
                        <cfset variables.categoriesResult = variables.adminHomeObject.getCategories()>
                            <cfloop query="variables.categoriesResult">
                                <div class="eachCategory mb-2">
                                    <div>
                                        <span id="categoryEdit#variables.categoriesResult.fldCategory_ID#">#variables.categoriesResult.fldCategoryName#</span>
                                    </div>
                                    <div>
                                        <button class="categoriesButton" value="#variables.categoriesResult.fldCategory_ID#" onclick="editCategory(this)" data-bs-toggle="modal" data-bs-target="##staticBackdrop">
                                            <i class="fa-solid fa-pen-to-square"></i>
                                        </button>
                                        <button class="categoriesButton" value="#variables.categoriesResult.fldCategory_ID#" onclick="deleteCategory(this)">
                                            <i class="fa-solid fa-trash"></i>
                                        </button>
                                        <a class="categoriesButton toolti px-2" href="./adminHomeSubcategory.cfm?categoryId=#variables.categoriesResult.fldCategory_ID#">
                                            <i class="fa-solid fa-chevron-right"></i>
                                            <span class="tooltiptext">Go to Sub-category</span>
                                        </a>
                                    </div>
                                </div>
                            </cfloop>
                    </div>
                </div>
            </div>
        </cfoutput>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="./Script/adminPage.js"></script>
    </body>
</html>