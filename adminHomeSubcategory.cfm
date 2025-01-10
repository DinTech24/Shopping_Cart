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
            <cfset adminSubCateObject = new Component.adminComponent()>
            <cfset subcategoriesResult = adminSubCateObject.listSubcategories("#url.categoryId#")>
            <cfif structKeyExists(form,"subcatgoryEdit")>
                <cfset subcategoryEditResult = adminSubCateObject.editSubCategoryFunction(editSubCategory,form.categorySelect,form.subcatgoryEdit)>
            </cfif>
            <!---Add Modal --->
            <div class="modal fade" id="staticBackdropAdd" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <form method="POST" id="adminCategoryForm">
                    <div class="modal-dialog">
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
                                <button type="button" id="categorySubmitButton" value="#url.categoryId#" onclick="subCategoryValidation()" class="btn btn-primary">Submit</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <!---Edit Modal --->
            <cfset editSubcategoriesResult = adminSubCateObject.getCategories()>
            <div class="modal fade" id="staticBackdropEdit" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <form method="POST" id="adminSubCategoryForm">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="staticBackdropLabelEdit">Edit Subcategory</h5>
                            </div>
                            <div class="modal-body">
                                <input type="text" class="form-control" name="editSubCategory" id="editSubCategoryId" name="category" placeholder="Enter new sub-category name">
                                <div class="warning" id="addcategoryWarning"></div>
                                    <select class="form-control mt-3" name="categorySelect">
                                        <cfloop query="editSubcategoriesResult">
                                            <option id='#editSubcategoriesResult.fldCategory_ID#Category' value="#editSubcategoriesResult.fldCategory_ID#">#editSubcategoriesResult.fldCategoryName#</option>
                                        </cfloop>
                                    </select>
                                <div class="warning" id="addcategoryWarning"></div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" onclick="closeAdminModal()" data-bs-dismiss="modal">Close</button>
                                <button type="submit" id="subcategorySubmitButton" name="subcatgoryEdit" class="btn btn-primary">Submit</button>
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
                    <button onclick="logout()">Logout</button>
                </div>
            </div>
            <div class="adminMainDiv w-100">
                <div class="mx-auto w-25" >
                    <a href="./adminHomePage.cfm" class="backToCategories"><i class="fa-solid fa-arrow-left"></i> Back to Categories Page</a>
                </div>
                <div class="categoriesDivision mx-auto">
                    <div class="my-2">
                        <span>Sub-Categories</span>
                        <button class="categoriesAdd" data-bs-toggle="modal" data-bs-target="##staticBackdropAdd">Add +</button>
                    </div>
                    <cfloop query="subcategoriesResult">
                        <div class="eachCategory mb-2" id="eachSub#subcategoriesResult.fldSubCategory_ID#">
                            <div>
                                <span id="#subcategoriesResult.fldSubCategory_ID#">#subcategoriesResult.fldSubCategoryName#</span>
                            </div>
                            <div>
                                <button class="categoriesButton" onclick="editSubcategoryModal(this,#url.categoryId#)" value="#subcategoriesResult.fldSubCategory_ID#"  data-bs-toggle="modal" data-bs-target="##staticBackdropEdit">
                                    <i class="fa-solid fa-pen-to-square"></i>
                                </button>
                                <button class="categoriesButton" value="#subcategoriesResult.fldSubCategory_ID#" onclick="deleteSubCategory(this)">
                                    <i class="fa-solid fa-trash"></i>
                                </button>
                                <a class="categoriesButton px-2" href="">
                                    <i class="fa-solid fa-chevron-right"></i>
                                </a>
                            </div>
                        </div>
                    </cfloop>
                </div>
            </div>
        </cfoutput>
        <script src="./Script/adminPage.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    </body>
</html>