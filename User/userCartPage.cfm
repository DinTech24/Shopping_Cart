<!DOCTYPE html>
<html lang="en">
    <head>
        <link rel="stylesheet" href="./Bootstrap/bootstrap.min.css">
        <link rel="stylesheet" href="./CSS/userStyle.css">
        <title>User_Cart_Page</title>
 	    <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css" integrity="sha512-Kc323vGBEqzTmouAECnVceyQqyqdsSiqLQISBL29aUW4U/M7pSPA/gEUZQqv1cwx4OnYxTxve5UMg5GT6L4JJg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Nunito:ital,wght@0,200..1000;1,200..1000&display=swap" rel="stylesheet">
    </head>
    <body class="hideScroll">
        <cfoutput>
            <cfset variables.userCartObject = new Component.userComponent()>
            <cfif structKeyExists(url,"productId")>
                <cfset variables.cartResult = userCartObject.addToCart(productId = url.productId)>
                <cflocation  url="./userCartPage.cfm">
            </cfif>
            <cfset variables.cartProductDisplayResult = variables.userCartObject.displayCart()>
            <cfset variables.totalPrice = 0>
            <cfset variables.totalTax = 0>
            <cfset variables.quantityPrice = 0>
            <cfset variables.quantityTax = 0>
            <cfset variables.productQuantity = 0>
            <cfinclude  template="./userHeader.cfm">
            <div class="cartPageMain" id="cartPageMainId">
                <div class="productDescription">
                    <cfloop query="variables.cartProductDisplayResult">
                        <cfset variables.productQuantity = variables.productQuantity + 1>
                        <div class="mainSectionBody " id="#variables.cartProductDisplayResult.fldCart_ID#CartProduct">
                            <div class="orderDetailsDiv pt-4">
                                <a href="./productPage.cfm?productId=#variables.cartProductDisplayResult.fldProduct_ID#">
                                    <img class="cartImage" src="../Assets/ProductImages/#variables.cartProductDisplayResult.fldImageFileName#" alt="">
                                </a>
                                <div class="mt-2 ms-5">
                                    <div class="productNameSize">#variables.cartProductDisplayResult.fldProductName#</div>
                                    <span class="orderDetailsSpan1">#variables.cartProductDisplayResult.fldBrandName#</span>
                                    <div class="mt-3">	
                                        <div class="orderDetailsSpan3 mt-1">
                                            Product Price : 
                                            <span>
                                                <i class="fa-solid fa-indian-rupee-sign"></i>
                                                <span id="#variables.cartProductDisplayResult.fldCart_ID#unitprice">
                                                    #variables.cartProductDisplayResult.fldPrice#
                                                </span>
                                            </span>
                                        </div>
                                        <div class="orderDetailsSpan3 mt-1">
                                            Product Tax : 
                                            <span>
                                            <i class="fa-solid fa-indian-rupee-sign"></i>
                                                <span id="#variables.cartProductDisplayResult.fldCart_ID#unittax">
                                                    #variables.cartProductDisplayResult.fldTax#
                                                </span>
                                            </span>
                                        </div>
                                        <div class="orderDetailsSpan mt-4">
                                            Product Total Amount : <i class="fa-solid fa-indian-rupee-sign"></i>
                                            #variables.cartProductDisplayResult.fldPrice + variables.cartProductDisplayResult.fldTax#
                                        </div>
                                    </div>	
                                </div>
                            </div>
                            <div class="d-flex w-50 ms-5 mt-2 justify-content-between mb-3">
                                <div>
                                    <button class="prquanityIncrease" value="#variables.cartProductDisplayResult.fldCart_ID#" onclick="reduceProductQuantity(this)">-</button>
                                    <span class="prquanity" id="#variables.cartProductDisplayResult.fldCart_ID#quantity">#variables.cartProductDisplayResult.fldQuantity#</span>
                                    <button class="prquanityIncrease" value="#variables.cartProductDisplayResult.fldCart_ID#" id="addProductButton" onclick="addProductQuantity(this,#variables.productQuantity#)">+</button>
                                </div>
                                <button value="#variables.cartProductDisplayResult.fldCart_ID#" onclick="removeCart(this)" class="fontWeight">REMOVE</button>
                            </div>
                        </div>
                        <cfset quantityPrice = variables.quantityPrice + (variables.cartProductDisplayResult.fldPrice * variables.cartProductDisplayResult.fldQuantity)>
                        <cfset quantityTax = variables.quantityTax + (variables.cartProductDisplayResult.fldTax * variables.cartProductDisplayResult.fldQuantity)>
                    </cfloop>
                    <cfif productQuantity NEQ 0>
                        <div class="w-100 placeOrderDiv">
                                <div class="placeOrderButton" name="placeorder">
                                    <a class="placeorderAnchor" href="./userOrderPage.cfm">PLACE ORDER</a>
                                </div>
                        </div>
                        <cfelse>
                            <div class="d-flex justify-content-center">
                                <img class="" src="../Assets/SiteImages/Empty_Shopping.jpg">
                            </div>
                            <div class="text-center mt-3">
                                <a class="continueShopping">
                                    Continue Shopping
                                    <i class="fa-solid fa-right-long"></i>
                                </a>
                            </div>
                    </cfif>
                </div>
                <cfif productQuantity NEQ 0>
                    <div class="productPrice">
                        <div class="priceDetails px-4">PRICE DETAILS</div>
                        <div class="detailedAmountInnerDiv">
                            <div class="d-flex justify-content-between px-4 pb-3 pt-2"> 
                                <span>Total Price</span>
                                <span>
                                    <i class="fa-solid fa-indian-rupee-sign"></i>
                                    <span id="totalprice">
                                        #quantityPrice#
                                    </span>
                                </span>
                            </div>
                            <div class="d-flex justify-content-between px-4 pb-3">
                                <span>Total Tax</span>
                                <span>
                                    <i class="fa-solid fa-indian-rupee-sign"></i>
                                    <span id="totaltax">
                                        #quantityTax#</span>
                                    </span>
                                </div>
                            <div class="d-flex justify-content-between px-4 pb-2"> 
                                <span>Delivery Charges</span><span><i class="fa-solid fa-indian-rupee-sign"></i> 40</span> 
                            </div>
                        </div>				
                        <div class="d-flex justify-content-between mx-4 pb-4 pt-4 fs-6 fw-bold borderDotted"> 
                            <span>Total Amount</span> 
                            <span>
                                <i class="fa-solid fa-indian-rupee-sign"></i>
                                <span id="totalamount">
                                    #quantityPrice + quantityTax + 40#
                                </span>
                            </span>
                        </div>
                    </div>
                </cfif>
            </div>
        </cfoutput>
        <cfinclude  template="./footer.cfm">
        <script src="./Script/userPage.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
    </body>
</html>