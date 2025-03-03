function logoutFunction(){
    $.ajax({
        type:"POST",
        url:"Component/userComponent.cfc?method=logoutUser",
        success:function(){
            window.location.href = "./userhomePage.cfm"
        }
    })
}

function closeUserModal(){
    document.getElementById("userLoginForm").reset();
}

function modalClear(){
    document.getElementById("userLoginForm").reset();
    document.getElementById("passWarning").innerHTML = ""
    document.getElementById("emailWarning").innerHTML = ""
}

function enableInputs(){
    document.getElementById("minVal").disabled = false;
    document.getElementById("maxVal").disabled = false;
}

function disableInputs(){
    document.getElementById("minVal").disabled = true;
    document.getElementById("maxVal").disabled = true;
}

function getFilterResult(subCategoryId){
    var flag = false;
    var minVal = document.getElementById("minVal").value;
    var maxVal = document.getElementById("maxVal").value;
    for(i=1;i<=4;i++){
        if(document.getElementById("filterRadio"+i).checked){
            flag = true
            var filterRangeVal = document.getElementById("filterRadio"+i).value;
            break;
        }else{
            if((i==4)&&(flag == false)){
                if((minVal=="")&&(maxVal=="")){
                    Swal.fire("Select a Range to continue");
                }else{
                    var filterRangeVal=`["${minVal}","${maxVal}"]`
                    flag=true
                }
            }
        }
    }
    if(flag==true){
        $.ajax({
            type:"POST",
            url:"Component/userComponent.cfc?method=selectPriceRange",
            data:{filterRange:filterRangeVal,subCategoryId:subCategoryId},
            success:function(result){
                var result = JSON.parse(result)
                document.getElementById("randomProductsMainDivId").innerHTML = ""
                var viewMoreDiv = document.getElementById("viewMore")
                if(viewMoreDiv != null){
                    viewMoreDiv.style.display = "none"
                }
                if(result.length == 0){
                    var emptyStatement = "No products to display in the price range"
                    $("#randomProductsMainDivId").append(emptyStatement);
                }else{
                    for(j=0;j<result.length;j++){
                        var eachProducts = 
                        `<div class="card randomProductCard" style="width: 13rem;">
                            <a class="text-decoration-none" href="./productPage.cfm?productId=${result[j].fldProduct_ID}">
                                <img src="../Assets/ProductImages/${result[j].fldImageFileName}" class="card-img-top randProductImage" alt="Product Image">
                                <div class="card-body randProductbody">
                                    <div class="card-text randProductName">${result[j].fldProductName}</div>
                                    <div class="text-dark">${result[j].fldBrandName}</div>
                                    <div class="card-text randProductPrice">
                                        <i class="fa-solid fa-indian-rupee-sign"></i>
                                        ${result[j].fldPrice + (result[j].fldTax * result[j].fldPrice)/100}
                                    </div>
                                </div>
                            </a>
                        </div>`
                        $("#randomProductsMainDivId").append(eachProducts);
                    }
                }
            }
        })
    }
    document.getElementById("minVal").value = ""
    document.getElementById("maxVal").value = ""
}

function addProductQuantity(cartId){
    var prQuantity = document.getElementById(cartId.value+"quantity").innerHTML;
    $.ajax({
        type:"POST",
        url:"Component/userComponent.cfc?method=updateCartQuantity",
        data:{cartId:cartId.value,prQuantity:Number(prQuantity)+1},
        success:function(){
            var prQuantity = document.getElementById(cartId.value+"quantity").innerHTML;
            document.getElementById(cartId.value+"quantity").innerHTML = Number(prQuantity) + 1
            var prQuantity = document.getElementById(cartId.value+"quantity").innerHTML;
            var price = document.getElementById(cartId.value+"unitprice").innerHTML;
            var tax = document.getElementById(cartId.value+"unittax").innerHTML;
            var totalprice = document.getElementById("totalprice").innerHTML;
            var totaltax = document.getElementById("totaltax").innerHTML;
            var totalamount = document.getElementById("totalamount").innerHTML;
            document.getElementById("totalprice").innerHTML = (Number(totalprice) + Number(price)).toFixed(1);
            document.getElementById("totaltax").innerHTML = (Number(totaltax) +Number(tax)).toFixed(1);
            document.getElementById("totalamount").innerHTML = (Number(totalamount) + Number(tax) + Number(price)).toFixed(1);
        }
    })
}

function reduceProductQuantity(cartId){
    var prQuantity = document.getElementById(cartId.value+"quantity").innerHTML;
    $.ajax({
        type:"POST",
        url:"Component/userComponent.cfc?method=updateCartQuantity",
        data:{cartId:cartId.value,prQuantity:Number(prQuantity)-1},
        success:function(){
            var prQuantity = document.getElementById(cartId.value+"quantity").innerHTML;
            document.getElementById(cartId.value+"quantity").innerHTML = Number(prQuantity) - 1
            var prQuantity = document.getElementById(cartId.value+"quantity").innerHTML;
            var price = document.getElementById(cartId.value+"unitprice").innerHTML;
            var tax = document.getElementById(cartId.value+"unittax").innerHTML;
            var totalprice = document.getElementById("totalprice").innerHTML;
            var totaltax = document.getElementById("totaltax").innerHTML;
            var totalamount = document.getElementById("totalamount").innerHTML;
            document.getElementById("totalprice").innerHTML = (Number(totalprice) - Number(price)).toFixed(1);
            document.getElementById("totaltax").innerHTML = (Number(totaltax) - Number(tax)).toFixed(1);
            document.getElementById("totalamount").innerHTML = ((Number(totalamount) - Number(tax)) - Number(price)).toFixed(1);
            if(prQuantity <= 0){
                document.getElementById(cartId.value+"CartProduct").remove()
                var producttotalQuantity = document.getElementById("productQuantityId").innerHTML;
                document.getElementById("productQuantityId").innerHTML = Number(producttotalQuantity)-1;
                var producttotalQuantity = document.getElementById("productQuantityId").innerHTML;
                if(producttotalQuantity <= 0){
                    document.getElementById("cartPageMainId").innerHTML = 
                        `
                        <div>
                            <div class="d-flex justify-content-center">
                                <img src="../Assets/SiteImages/Empty_Shopping.jpg">
                            </div>
                            <div class="text-center mt-3">
                                <a class="continueShopping" href="./userhomePage.cfm">
                                    Continue Shopping
                                    <i class="fa-solid fa-right-long"></i>
                                </a>
                            </div>
                        </div>
                        `   
                }
                Swal.fire({
                    position: "top-end",
                    icon: "success",
                    title: "Product removed from Cart",
                    showConfirmButton: false,
                    toast:true,
                    timer: 1500,
                    theme:"dark"
                });
            }
        }
    })
}

function removeCart(cartId){
    Swal.fire({
        title: "Are you sure to remove?",
        text: "You won't be able to revert this!",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Yes, remove it!"
      }).then((result) => {
        if (result.isConfirmed) {
          Swal.fire({
            title: "Removed!",
            text: "Product has been removed from cart.",
            icon: "success"
        });
        var prQuantity = document.getElementById(cartId.value+"quantity").innerHTML;
        var price = document.getElementById(cartId.value+"unitprice").innerHTML;
        var tax = document.getElementById(cartId.value+"unittax").innerHTML;
        var totalprice = document.getElementById("totalprice").innerHTML;
        var totaltax = document.getElementById("totaltax").innerHTML;
        var totalamount = document.getElementById("totalamount").innerHTML;
        var qtyPrice = Number(prQuantity)*Number(price)
        var qtyTax = Number(prQuantity)*Number(tax)
        var totalQtyAmount = qtyPrice + qtyTax;
        document.getElementById("totalamount").innerHTML = Number(totalamount) - totalQtyAmount;
        document.getElementById("totalprice").innerHTML = (Number(totalprice) - Number(qtyPrice)).toFixed(1)
        document.getElementById("totaltax").innerHTML = (Number(totaltax) - Number(qtyTax)).toFixed(1)
        document.getElementById(cartId.value+"CartProduct").remove()
        var producttotalQuantity = document.getElementById("productQuantityId").innerHTML;
        document.getElementById("productQuantityId").innerHTML = Number(producttotalQuantity)-1;
        $.ajax({
            type:"POST",
            url:"Component/userComponent.cfc?method=deleteCart",
            data:{cartId:cartId.value}
        })
        var producttotalQuantity = document.getElementById("productQuantityId").innerHTML;
        if(producttotalQuantity == 0){
            document.getElementById("cartPageMainId").innerHTML = 
            `
            <div>
                <div class="d-flex justify-content-center">
                    <img src="../Assets/SiteImages/Empty_Shopping.jpg">
                </div>
                <div class="text-center mt-3">
                    <a class="continueShopping" href="./userhomePage.cfm">
                        Continue Shopping
                        <i class="fa-solid fa-right-long"></i>
                    </a>
                </div>
            </div>
            `
        }
    }
    });
}

function searchValidate(){
    var searchKey = document.getElementById("searchInput").value;
    if(searchKey.trim().length == 0){
        Swal.fire("Enter keyword to search");
        return false
    }else{
        document.getElementById("searchInput").value = searchKey.trim();
        return true
    }
}


function clearModal(){
    const nodeList = document.querySelectorAll(".registerWarning");
    const nodeListNew = document.querySelectorAll(".inputStyleNew");
    document.getElementById("userAddressForm").reset();
    for (let i = 0; i < nodeList.length; i++) {
        nodeList[i].innerHTML = "";
    }
    for (let j = 0; j < nodeListNew.length; j++) {
        nodeListNew[j].style.border = "1px solid black";
    }
}

function removeAddress(addressId){
    Swal.fire({
        title: "Do you want to remove address?",
        showDenyButton: true,
        confirmButtonText: "Yes",
        denyButtonText: `No`
      }).then((result) => {
        if (result.isConfirmed) {
          Swal.fire("Removed!", "", "success");
          $.ajax({
            type:"POST",
            url:"Component/userComponent.cfc?method=deleteAddress",
            data:{addressId:addressId.value},
            success:function(){
                    document.getElementById(addressId.value+"address").remove();
                }
        })
        } else if (result.isDenied) {
          Swal.fire("Address is not removed", "", "info");
        }
      });
}

function editUserProfile(userId){
    var userFirstName = document.getElementById("userFirstNameId").value
    var userLastName = document.getElementById("userLastNameId").value
    var userEmail = document.getElementById("userEmailId").value
    var userPhone = document.getElementById("userPhoneId").value
    var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    var phonePattern = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/;
    var flag = true;
    if(userFirstName.trim() == ""){
        document.getElementById("userFirstNameWarning").innerHTML = "firstname is empty"
        flag = false
    }else{
        document.getElementById("userFirstNameWarning").innerHTML = ""
    }
    if(userEmail.trim() == ""){
        document.getElementById("userEmailWarning").innerHTML = "email is empty"
        flag = false
    }else if(!emailPattern.test(userEmail)){
        document.getElementById("userEmailWarning").innerHTML = "email should follow pattern"
        flag = false
    }else{
        document.getElementById("userEmailWarning").innerHTML = ""
    }
    if(userPhone.trim() == ""){
        document.getElementById("userPhoneWarning").innerHTML = "phone number is empty"
        flag = false
    }else if(!phonePattern.test(userPhone)){
        document.getElementById("userPhoneWarning").innerHTML = "phone number should follow pattern"
        flag = false
    }else{
        document.getElementById("userPhoneWarning").innerHTML = ""
    }
    if(flag == true){
        $.ajax({
            type:"POST",
            url:"Component/userComponent.cfc?method=editUserProfile",
            data:{
                userId:userId,
                userFirstName:userFirstName,
                userLastName:userLastName,
                userEmail:userEmail,
                userPhone:userPhone
            },
            success:function(result){
                result = JSON.parse(result);
                if(result == true){
                    document.getElementById("userDataName").innerHTML = userFirstName + " " + userLastName;
                    document.getElementById("userDataEmail").innerHTML = userEmail;
                    document.getElementById("userDataPhone").innerHTML = userPhone;
                    document.getElementById("profileModalClose").click();
                    Swal.fire({
                        position: "top-end",
                        icon: "success",
                        title: "Your Profile has been updated",
                        showConfirmButton: false,
                        toast:true,
                        timer: 1500,
                        theme:"dark"
                    });
                }else{
                    Swal.fire("User already exists");
                }
            }
        })
    }
}

function loadAllProducts(productsIdArray,offsetValue){
    $.ajax({
        type:"POST",
        url:"Component/userComponent.cfc?method=loadMoreData",
        data:{productIdList:productsIdArray,offsetValue:offsetValue.value},
        success:function(result){
            var result = JSON.parse(result)
            for(j=0;j<result.length;j++){
                var eachProducts = 
                `<div class="card randomProductCard" style="width: 13rem;">
                    <a class="text-decoration-none" href="./productPage.cfm?productId=${result[j].fldProduct_ID}">
                        <img src="../Assets/ProductImages/${result[j].fldImageFileName}" class="card-img-top randProductImage" alt="Product Image">
                        <div class="card-body randProductbody">
                            <div class="card-text randProductName">${result[j].fldProductName}</div>
                            <div class="text-dark">${result[j].fldBrandName}</div>
                            <div class="card-text randProductPrice">
                                <i class="fa-solid fa-indian-rupee-sign"></i>
                                ${result[j].fldPrice + (result[j].fldTax * result[j].fldPrice)/100}
                            </div>
                        </div>
                    </a>
                </div>`
                $("#randomProductsMainDivId").append(eachProducts);
            }
            document.getElementById("loadMoreData").value = Number(offsetValue.value) + 12;
            if(result.length < 12){
                document.getElementById("viewMore").remove();
            }
        }
    })
}

function addBuyQuantity(){
    var totalprice = document.getElementById("totalprice").innerHTML;
    var totaltax = document.getElementById("totaltax").innerHTML;
    var productQuantity = document.getElementById("ProductQuantitySpan").innerHTML;
    var unitPrice = document.getElementById("buyNowPrice").innerHTML;
    var unitTax = document.getElementById("buyNowTax").innerHTML;
    var totalAmount = document.getElementById("totalAmount").innerHTML
    document.getElementById("reduceQuantity").disabled = false;
    document.getElementById("ProductQuantitySpan").innerHTML = Number(productQuantity) + 1
    var productQuantity = document.getElementById("ProductQuantitySpan").innerHTML;
    document.getElementById("totalprice").innerHTML = (Number(totalprice) + Number(unitPrice)).toFixed(1);
    document.getElementById("totaltax").innerHTML = (Number(totaltax) + Number(unitTax)).toFixed(1);
    document.getElementById("totalAmount").innerHTML = (Number(totalAmount) + Number(unitPrice) + Number(unitTax)).toFixed(1)
    document.getElementById("productQuanityHidden").value = Number(productQuantity);
}

function reduceBuyQuantity(){
    var totalprice = document.getElementById("totalprice").innerHTML;
    var totaltax = document.getElementById("totaltax").innerHTML;
    var productQuantity = document.getElementById("ProductQuantitySpan").innerHTML;
    var unitPrice = document.getElementById("buyNowPrice").innerHTML;
    var unitTax = document.getElementById("buyNowTax").innerHTML;
    var totalAmount = document.getElementById("totalAmount").innerHTML
    document.getElementById("ProductQuantitySpan").innerHTML = Number(productQuantity) - 1
    var productQuantity = document.getElementById("ProductQuantitySpan").innerHTML;
    document.getElementById("totalprice").innerHTML = (Number(totalprice) - Number(unitPrice)).toFixed(1);
    document.getElementById("totaltax").innerHTML = (Number(totaltax) - Number(unitTax)).toFixed(1);
    document.getElementById("totalAmount").innerHTML = (Number(totalAmount) - Number(unitPrice) - Number(unitTax)).toFixed(1)
    document.getElementById("productQuanityHidden").value = Number(productQuantity);
    if(productQuantity == 1){
        document.getElementById("reduceQuantity").disabled = true;
    }
}

function placeOrderFunction(){
    if(document.getElementById("addressDetailsId").value == 0){
        Swal.fire('Add a delivery address to continue');
        return false;
    }else{
        return true;
    }
}

window.addEventListener('pageshow', (event) => {
    if (event.persisted) {
      window.location.reload();
    }
});

function clearEditModal(){
    var fullName = document.getElementById("userDataName").innerHTML;
    var nameArray = fullName.split(" ");
    var firstName = nameArray[0];
    var secondName = nameArray[1];
    document.getElementById("userFirstNameId").value = firstName
    document.getElementById("userLastNameId").value = secondName
    document.getElementById("userEmailId").value = document.getElementById("userDataEmail").innerHTML
    document.getElementById("userPhoneId").value = document.getElementById("userDataPhone").innerHTML
    document.getElementById("userFirstNameWarning").innerHTML = "";
    document.getElementById("userEmailWarning").innerHTML = "";
    document.getElementById("userPhoneWarning").innerHTML = "";

} 

function searchOrder(){
    $('#searchOrderId').keyup(function() { 
        this.value = this.value.toLocaleUpperCase(); 
    });
}

function downloadConfirmation(){
    if(confirm("Confirm to download")){
        Swal.fire("Invoice Downloaded successfully");
        return true;
    }else{
        return false;
    }
}

if ( window.history.replaceState ) {
    window.history.replaceState( null, null, window.location.href );
}