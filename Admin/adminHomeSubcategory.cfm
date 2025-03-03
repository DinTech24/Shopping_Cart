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
            <cfset variables.adminSubCategoryObject = new Component.adminComponent()>
            <cfif structKeyExists(form,"subcatgoryEdit")>
                <cfset variables.subCategoryResult = variables.adminSubCategoryObject.editSubCategoryFunction(
                    newSubCategory = form.editSubCategory,
                    selectedCategory = form.categorySelect,
                    subCategoryId = form.subcatgoryEdit
                )>
            </cfif>
            <cfif structKeyExists(form,"subcategoryAddButton")>
                <cfset variables.subCategoryResult = variables.adminSubCategoryObject.addSubCategory(
                    newsubCategory = form.category,
                    categoryId = url.categoryId
                )>
            </cfif>
            <cfset variables.subcategoriesResult = variables.adminSubCategoryObject.listSubcategories("#url.categoryId#")>
            <!---Add Modal --->
            <div class="modal fade" id="staticBackdropAdd" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <div class="modal-dialog">
                    <form method="POST">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="staticBackdropLabel">Add New Subcategories</h5>
                            </div>
                            <div class="modal-body">
                                <input type="text" class="form-control border-dark" id="subCategoryId" name="category" placeholder="Enter new sub-category name">
                                <div class="warning" id="addcategoryWarning"></div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" onclick="closeAdminModal()" data-bs-dismiss="modal">Close</button>
                                <button type="submit" id="categorySubmitButton" name="subcategoryAddButton" onclick="return subCategoryValidation()" class="btn btn-primary">Submit</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
            <!---Edit Modal --->
            <cfset variables.categoryResult = variables.adminSubCategoryObject.getCategories()>
            <div class="modal fade" id="staticBackdropEdit" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <form method="POST" id="adminProductForm">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="staticBackdropLabelEdit">Edit Subcategory</h5>
                            </div>
                            <div class="modal-body">
                                <div>Enter Sub-Category Name</div>
                                <input type="text" class="form-control" name="editSubCategory" id="editSubCategoryId" name="category" placeholder="Enter new sub-category name">
                                <div class="warning" id="addDiffcategoryWarning"></div>
                                <div class=" mt-3">Select Category Name</div>
                                <select class="form-control" name="categorySelect">
                                    <cfloop query="variables.categoryResult">
                                        <option id='#variables.categoryResult.fldCategory_ID#Category' value="#variables.categoryResult.fldCategory_ID#">#variables.categoryResult.fldCategoryName#</option>
                                    </cfloop>
                                </select>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" onclick="closeAdminModal()" data-bs-dismiss="modal">Close</button>
                                <button type="submit" id="subcategorySubmitButton" onclick="return validateEditSub()" name="subcatgoryEdit" class="btn btn-primary">Submit</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="adminNavBar d-flex justify-content-between align-items-center p-3 mb-3">
                <div>
                    <img src="../Assets/SiteImages/LogoImage.png" height="50">
                    <span class="fs-3 fw-bold">eCart</span>
                    <span>ADMIN</span>
                </div>
                <div>
                    <button onclick="logout()" class="logoutButton">Logout</button>
                </div>
            </div>
            <div class="adminMainDiv w-100">
                <div class="mx-auto w-25" >
                    <a href="./adminHomePage.cfm" class="backToCategories"><i class="fa-solid fa-arrow-left"></i> Back to Categories Page</a>
                </div>
                <div class="categoriesDivision mx-auto">
                    <div class="my-2">
                        <span class="fs-3 fw-bold">#variables.subcategoriesResult.fldCategoryName#</span>
                        <button class="categoriesAdd" onclick="warningClear()" data-bs-toggle="modal" data-bs-target="##staticBackdropAdd">Add +</button>
                        <cfif structKeyExists(variables,"subCategoryResult")>
                            <cfif variables.subCategoryResult EQ false>
                                <span class="text-danger" id="serverErrorSpan">Same name exists</span>
                            <cfelse>
                                <span class="text-success" id="serverErrorSpan">Added Successfuly</span>
                            </cfif>
                        </cfif>
                        <span id="warningText" class="text-danger"></span>
                    </div>
                    <cfloop query="variables.subcategoriesResult">
                        <div class="eachCategory mb-2" id="eachSub#variables.subcategoriesResult.fldSubCategory_ID#">
                            <div>
                                <span id="#variables.subcategoriesResult.fldSubCategory_ID#">#variables.subcategoriesResult.fldSubCategoryName#</span>
                            </div>
                            <div>
                                <button class="categoriesButton" onclick="editSubcategoryModal(this,#url.categoryId#)" value="#variables.subcategoriesResult.fldSubCategory_ID#"  data-bs-toggle="modal" data-bs-target="##staticBackdropEdit">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                </button>
                                <button class="categoriesButton" value="#variables.subcategoriesResult.fldSubCategory_ID#" onclick="deleteSubCategory(this)">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                                <a class="categoriesButton toolti px-2" href="./adminHomeProduct.cfm?categoryId=#url.categoryId#&subCategoryId=#variables.subcategoriesResult.fldSubCategory_ID#">
                                    <i class="fa-solid fa-chevron-right"></i>
                                    <span class="tooltiptext">Go to Product Page</span>
                                </a>
                            </div>
                        </div>
                    </cfloop>
                </div>
            </div>
        </cfoutput>
        <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="./Script/adminPage.js"></script>
        <script src="../CommonScripts/validations.js"></script>
    </body>
</html>