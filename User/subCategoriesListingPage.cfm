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
            <cfset userCateObject = new Component.userComponent()>
            <cfset subCategoryResult = userCateObject.listSubCategories()>
            <cfif structKeyExists(form, "highSort")>
                <cfset randomProductsResult = userCateObject.getRandomProducts(sort = form.highSort)>
                <cfelseif structKeyExists(form, "lowSort")>
                    <cfset randomProductsResult = userCateObject.getRandomProducts(sort = form.lowSort)>
                <cfelseif structKeyExists(url, "searchKeyword")>
                    <cfset randomProductsResult = userCateObject.getRandomProducts(
                        searchKeyword = url.searchKeyword,
                        sort = "true"
                    )>
                <cfelse>
                    <cfset randomProductsResult = userCateObject.getRandomProducts(sort="negative")>
            </cfif>
            <cfinclude  template="./userHeader.cfm">
            <cfif NOT structKeyExists(url, "searchKeyword")>
                <cfloop query="subCategoryResult">
                    <cfif subCategoryResult.fldSubCategory_ID EQ url.subCategoryId>
                        <div class="p-3 d-flex justify-content-between px-2">
                            <h2>#subCategoryResult.fldSubcategoryName# - All Products</h2>
                            <form method="POST">
                                <div class="d-flex">
                                    <div class="me-3">
                                        <span class="sortText">Sort :</span>
                                        <button class="sortArrow text-success" value="ASC" name="highSort">
                                            <i class="fa-solid fa-arrow-up"></i>
                                        </button>
                                        <button class="sortArrow text-danger" value="DESC" name="lowSort">
                                            <i class="fa-solid fa-arrow-down"></i>
                                        </button>
                                    </div>
                                    <div class="filterMainClass">
                                        <div class="sortText filterClass mt-1">Filter<i class="fa-solid fa-filter"></i></div>
                                        <div class="d-grid filterInner">
                                            <div>Select Price Range :</div>
                                            <div class="d-flex">
                                                <input type="radio" id="filterRadio1" onclick="disableInputs()" value='["0","1000"]' class="filterInput" name="filter">
                                                <label>upto 1000</label>
                                            </div>
                                            <div class="d-flex">
                                                <input type="radio" id="filterRadio2" onclick="disableInputs()" value='["1000","10000"]'class="filterInput" name="filter">
                                                <label>1000 to 10000</label>
                                            </div>
                                            <div class="d-flex">
                                                <input type="radio" id="filterRadio3" onclick="disableInputs()" value='["10000","25000"]' class="filterInput" name="filter">
                                                <label>10000 to 25000</label>
                                            </div>
                                            <div class="d-flex">
                                                <input type="radio" id="filterRadio4" onclick="disableInputs()" value='["25000","200000"]' class="filterInput" name="filter">
                                                <label>25000 to 200000</label>
                                            </div>
                                            <div class="d-flex">
                                                <input type="radio" id="filterRadio5" onclick="enableInputs()" value='range' class="filterInput" name="filter">
                                                <label>Custom Range</label>
                                            </div>
                                            <div class="text-center">
                                                <div class="mt-2">
                                                    <input type="text" disabled id="minVal" placeholder="MIN" class="selectRange form-control border-danger">
                                                    <div class="text-center fw-bold">Select Range</div>
                                                    <input type="text" disabled id="maxVal" placeholder="MAX" class="selectRange form-control border-success">
                                                </div>
                                                <button type="button" class="btn btn-primary mt-2" onclick="getFilterResult(#url.subCategoryId#)">Show result</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            <form>
                        </div>
                    </cfif>
                </cfloop>
                <cfelse>
                    <cfif queryRecordCount(randomProductsResult)>
                            <h4 class="m-3">Results for your search "#url.searchKeyword#"</h4>
                        <cfelse>
                        <h4 class="m-3">No result based on your search "#url.searchKeyword#"</h4>
                    </cfif>
            </cfif>
            <div>
                <div>
                    <div class="randomProductsMainDiv initialDivHeight" id="randomProductsMainDivId">
                        <cfset productsCount = 0>
                        <cfloop query="randomProductsResult">
                            <cfif structKeyExists(url, "subCategoryId")>
                                <cfif randomProductsResult.fldSubCategoryId EQ url.subCategoryId>
                                    <cfset productsCount = productsCount + 1>
                                    <div class="card randomProductCard" style="width: 13rem;">
                                        <a href="./productPage.cfm?productId=#randomProductsResult.fldProduct_ID#">
                                            <img src="../Assets/ProductImages/#randomProductsResult.fldImageFileName#" class="card-img-top randProductImage" alt="Product Image">
                                        </a>
                                        <div class="card-body randProductbody">
                                            <div class="card-text randProductName">#randomProductsResult.fldProductName#</div>
                                            <div>#randomProductsResult.fldBrandName#</div>
                                            <div class="card-text randProductPrice">
                                                <i class="fa-solid fa-indian-rupee-sign"></i>
                                                #randomProductsResult.fldPrice + randomProductsResult.fldTax#
                                            </div>
                                        </div>
                                    </div>
                                </cfif>
                                <cfelse>
                                    <cfset productsCount = productsCount + 1>
                                    <div class="card randomProductCard" style="width: 13rem;">
                                        <a href="./productPage.cfm?productId=#randomProductsResult.fldProduct_ID#">
                                            <img src="../Assets/ProductImages/#randomProductsResult.fldImageFileName#" class="card-img-top randProductImage" alt="Product Image">
                                        </a>
                                        <div class="card-body randProductbody">
                                            <div class="card-text randProductName">#randomProductsResult.fldProductName#</div>
                                            <div>#randomProductsResult.fldBrandName#</div>
                                            <div class="card-text randProductPrice">
                                                <i class="fa-solid fa-indian-rupee-sign"></i>
                                                #randomProductsResult.fldPrice + randomProductsResult.fldTax#
                                            </div>
                                        </div>
                                    </div>
                            </cfif>
                        </cfloop>
                    </div>
                </div>
            </div>
            <cfif productsCount GT 12>
                <div class="text-center mb-3" id="viewMore">
                    <button type="button" class="viewMoreButton" onclick="removeHeightClass()">
                        load more products
                        <i class="fa-solid fa-sort-down"></i>
                    </button>
                </div>
            </cfif>
            <cfinclude  template="./footer.cfm">
        </cfoutput>
        <script src="./Script/userPage.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    </body>
</html>