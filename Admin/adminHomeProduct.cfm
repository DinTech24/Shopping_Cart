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
            <cfset variables.adminProductObject = new Component.adminComponent()>
            <cfset variables.getCategory = variables.adminProductObject.getCategories()>
            <cfset variables.getSubCategory = variables.adminProductObject.listSubcategories(
                categoryId = url.categoryId,
                jscall = true
            )>
            <cfset variables.getBrandsData = variables.adminProductObject.getBrands()>
            <cfset variables.createErrorVar["flag"] = true>
            <cfif structKeyExists(form, "productSubmit")>
                <cfset variables.createErrorVar = variables.adminProductObject.insertProduct(dataStructure = form)>
            </cfif>
            <cfif structKeyExists(form, "productEdit")>
                <cfset variables.createErrorVar = variables.adminProductObject.updateProduct(editDataStructure = form)>
            </cfif>
            <cfset variables.getProductData = variables.adminProductObject.getProducts(subCategoryId = url.subCategoryId)>
            <div class="modal fade" id="staticProductImageModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <form method="POST" >
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="staticBackdropHead">Product Images</h5>
                            </div>
                            <div class="modal-body">
                                <div id="carouselControls" class="carousel slide" data-bs-ride="carousel">
                                    <div class="carousel-inner" id="carousel-inner">
                                        <div id="carousel-button"></div>
                                    </div>
                                    <button class="carousel-control-prev carousalcontrol" type="button" data-bs-target="##carouselControls" data-bs-slide="prev">
                                        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                                        <span class="visually-hidden">Previous</span>
                                    </button>
                                    <button class="carousel-control-next carousalcontrol " type="button" data-bs-target="##carouselControls" data-bs-slide="next">
                                        <span class="carousel-control-next-icon" aria-hidden="true"></span>
                                        <span class="visually-hidden">Next</span>
                                    </button>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary w-100" onclick="closeAdminImageModal()" data-bs-dismiss="modal">Close</button>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal fade" id="staticBackdropModal" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
                <form method="POST" id="adminProductForm" enctype="multipart/form-data">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="staticBackdropLabel"></h5>
                            </div>
                            <div class="modal-body">
                                <div class="productData">
                                    <label>Category Name</label>
                                    <select required name="categoryname" id="categoriesSelect" onChange="getSubCategoriesFunction()" id="categoryName">
                                        <cfloop query="getCategory">
                                            <option id="#variables.getCategory.fldCategory_ID#cate" value="#variables.getCategory.fldCategory_ID#">
                                                #variables.getCategory.fldCategoryName#
                                            </option>
                                        </cfloop>
                                    </select>
                                </div>
                                <div class="productData">
                                    <label>SubCategory Name</label>
                                    <select name="subcategoryname" required id="subcategoriesSelect">
                                        <cfloop collection="#variables.getSubCategory#" item="dataItem">
                                            <option value="#variables.dataItem#" id="#variables.dataItem#subcate">#variables.getSubCategory[dataItem]#</option>
                                        </cfloop>
                                    </select>
                                </div>
                                <div class="productData">
                                    <label>Product Name</label>
                                    <input name="productname" required type="text" id="productNameId" placeholder="Product Name">
                                </div>
                                <div class="productData">
                                    <label>Product Brand</label>
                                    <select name="brandname" required id="selectBrandId">
                                        <cfloop query="#variables.getBrandsData#">
                                            <option value="#variables.getBrandsData.fldBrand_ID#" id="#variables.getBrandsData.fldBrand_ID#brand">#variables.getBrandsData.fldBrandName#</option>
                                        </cfloop>
                                    </select>
                                </div>
                                <div class="productData">
                                    <label>Product Description</label>
                                    <textarea name="descriptionname" required id="productdescriptionId" placeholder="Product Description"></textarea>
                                </div>
                                <div class="productData">
                                    <label>Product Price</label>
                                    <input name="pricename" step="0.01" id="productPriceId" type="number" placeholder="Product Price">
                                </div>
                                <div class="productData">
                                    <label>Product Tax</label>
                                    <input name="taxname" step="0.01" required id="producttaxId" type="number" placeholder="Product Tax">
                                </div>
                                <div id="productImageDivId">
                                    <label>Product Image</label>
                                    <input name="imagesname" required id="productImageId" type="file" class="form-control" multiple>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" onclick="closeAdminModal()" data-bs-dismiss="modal">Close</button>
                                <button type="submit" id="productSubmitButton" name="productSubmit" class="btn btn-primary">Submit</button>
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
                    <button class="logoutButton"  onclick="logout()">Logout</button>
                </div>
            </div>
            <div class="adminMainDiv w-100">
                <div class="mx-auto w-25" >
                    <a href="./adminHomeSubcategory.cfm?CategoryId=#url.CategoryId#" class="backToCategories"><i class="fa-solid fa-arrow-left"></i> Back to Sub-Categories Page</a>
                </div>
                <div class="productDivision  mx-auto">
                    <div class="my-2">
                        <span>Products Page</span>
                        <button class="categoriesAdd" onclick="openProductModal(#url.categoryId#,#url.subCategoryId#)" data-bs-toggle="modal" data-bs-target="##staticBackdropModal">Add +</button>
                        <cfif variables.createErrorVar["flag"] EQ false>
                            <span class="text-danger ms-2 fw-bold" id="serverErrorSpan">#variables.createErrorVar["exception"]#</span>
                        </cfif>
                    </div>
                    <div class="productsDivision">
                        <cfloop query="variables.getProductData">
                            <div class="eachCategory mb-3" id="#variables.getProductData.fldProduct_ID#product">
                                <div>
                                    <div class="productName">#variables.getProductData.fldProductName#</div>
                                    <div class="productBrand">#variables.getProductData.fldBrandName#</div>
                                    <div class="productPrice">#variables.getProductData.fldPrice#</div>
                                </div>
                                <div class="imagePoint">
                                    <button class="carousalimageButton " onclick="addcarousalImage(this)" value="#variables.getProductData.fldProduct_ID#">
                                        <img height="100"   src="../Assets/ProductImages/#variables.getProductData.fldImageFileName#" alt="ProductImage" data-bs-toggle="modal" data-bs-target="##staticProductImageModal">
                                    </button>
                                </div>
                                <div>
                                    <button value="#variables.getProductData.fldProduct_ID#" class="categoriesButton" onclick="updateProductFunction(this,#url.categoryId#,#url.subCategoryId#)" data-bs-toggle="modal" data-bs-target="##staticBackdropModal">
                                        <i class="fa-solid fa-pen-to-square"></i>
                                    </button>
                                    <button value="#variables.getProductData.fldProduct_ID#" class="categoriesButton" onclick="deleteProduct(this)"><i class="fa-solid fa-trash"></i></button>
                                </div>
                            </div>
                        </cfloop>
                    </div>
                </div>
            </div>
        </cfoutput>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="./Script/adminPage.js"></script>
    </body>
</html>