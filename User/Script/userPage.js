function registerUser(){
    var firstName = document.getElementById("firstNameId").value;
    var emailId = document.getElementById("emailIds").value;
    var password = document.getElementById("passwordId").value;
    var rePassword = document.getElementById("rePasswordId").value;
    var phone = document.getElementById("phoneId").value;
    var emailPattern = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
    var phonePattern = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/;
    var flag = true;

    if(firstName.trim() === ""){
        document.getElementById("nameWarning").innerHTML = "Firstname is required"
        flag = false;
    }else{
        document.getElementById("nameWarning").innerHTML = ""
    }

    if(phone.trim() === ""){
        document.getElementById("phoneWarning").innerHTML = "add phone number";
        flag = false;
    }else{
        if(phonePattern.test(phone) === false){
            document.getElementById("phoneWarning").innerHTML = "phone should follow the pattern";
            flag = false;
        }else{
            document.getElementById("phoneWarning").innerHTML = ""
        }
    }

    if(emailId.trim() === ""){
        document.getElementById("emailWarning").innerHTML = "email-id is required"
        flag = false;
    }else{
        if(emailPattern.test(emailId) === false){
            document.getElementById("emailWarning").innerHTML = "should follow email Pattern"
            flag = false;
        }else{
            document.getElementById("emailWarning").innerHTML = ""
        }
    }


    if(password.trim() === ""){
        document.getElementById("passWarning").innerHTML = "password is required"
        flag = false;
    }else{
        if(password.includes(" ")){
            document.getElementById("passWarning").innerHTML = "password shouldn't contain spaces"
            flag = false;
        }else if(password.length < 6){
            document.getElementById("passWarning").innerHTML = "password should atleast have 6 characters"
            flag = false;
        }else if(password !== rePassword){
            document.getElementById("passWarning").innerHTML = ""
            document.getElementById("repassWarning").innerHTML = "passwords doesn't match"
            flag = false;
        }else{
            document.getElementById("repassWarning").innerHTML = ""
            document.getElementById("passWarning").innerHTML = ""
        }
    }
    
    if(flag == false){
        event.preventDefault();
    }
    return flag;
}

function logoutFunction(){
    if(confirm("Confirm to logout")){
        $.ajax({
            type:"POST",
            url:"Component/userComponent.cfc?method=logoutUser",
            success:function(){
                    window.location.href = "./userhomePage.cfm"
                }
        })
    }
}

function closeUserModal(){
    document.getElementById("userLoginForm").reset();
}

function loginModal(){
    document.getElementById("passWarning").innerHTML = ""
    document.getElementById("emailWarning").innerHTML = ""
    var emailId = document.getElementById("emailIds").value;
    var password = document.getElementById("passwordId").value;
    var flag = true;
    if(emailId.trim() === ""){
        document.getElementById("emailWarning").innerHTML = "EmailId is required"
        flag = false;
    }else{
        document.getElementById("emailWarning").innerHTML = ""
    }
    if(password.trim() === ""){
        document.getElementById("passWarning").innerHTML = "Password is required"
        flag = false;
    }else{
        document.getElementById("passWarning").innerHTML = ""
    }
    if(flag)
        var jsCall = true;
        $.ajax({
            type:"POST",
            url:"Component/userComponent.cfc?method=loginUser",
            data:{enteredId:emailId,enteredPassword:password,jsCall:jsCall},
            success:function(result){
                if(result){
                    result = JSON.parse(result);
                    event.preventDefault();
                    if(result["Message"] == "true"){
                        location.reload();
                    }else{
                        document.getElementById("passWarning").innerHTML = result["Message"]
                    }
                    
                }
            }
        })
    
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
    minVal = document.getElementById("minVal").value;
    maxVal = document.getElementById("maxVal").value;
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
                if(result.length == 0){
                    var emptyStatement = "No products to display in the price range"
                    $("#randomProductsMainDivId").append(emptyStatement);
                    document.getElementById("viewMore").style.display = "none"
                }else{
                    for(j=0;j<result.length;j++){
                        var eachProducts = 
                        `<div class="card randomProductCard" style="width: 13rem;">
                            <a href="./productPage.cfm?productId=${result[j].fldProduct_ID}">
                                <img src="../Assets/ProductImages/${result[j].fldImageFileName}" class="card-img-top randProductImage" alt="Product Image">
                            </a>
                            <div class="card-body randProductbody">
                                <div class="card-text randProductName">${result[j].fldProductName}</div>
                                <div>${result[j].fldBrandName}</div>
                                <div class="card-text randProductPrice">
                                    <i class="fa-solid fa-indian-rupee-sign"></i>
                                    ${result[j].fldPrice + result[j].fldTax}
                                </div>
                            </div>
                        </div>`
                        $("#randomProductsMainDivId").append(eachProducts);
                        document.getElementById("viewMore").style.display = "initial"
                    }
                }
            }
        })
    }
}

function addProductQuantity(cartId){
    var prQuantity = document.getElementById(cartId.value+"quantity").innerHTML;
    document.getElementById(cartId.value+"quantity").innerHTML = Number(prQuantity) + 1
    var prQuantity = document.getElementById(cartId.value+"quantity").innerHTML;
    var price = document.getElementById(cartId.value+"unitprice").innerHTML;
    var tax = document.getElementById(cartId.value+"unittax").innerHTML;
    var totalprice = document.getElementById("totalprice").innerHTML;
    var totaltax = document.getElementById("totaltax").innerHTML;
    var totalamount = document.getElementById("totalamount").innerHTML;
    document.getElementById("totalprice").innerHTML = Number(totalprice) + Number(price);
    document.getElementById("totaltax").innerHTML = Number(totaltax) +Number(tax);
    document.getElementById("totalamount").innerHTML = Number(totalamount) + Number(tax) + Number(price);
    $.ajax({
        type:"POST",
        url:"Component/userComponent.cfc?method=updateCartQuantity",
        data:{cartId:cartId.value,prQuantity:prQuantity}
    })
}

function reduceProductQuantity(cartId){
    var prQuantity = document.getElementById(cartId.value+"quantity").innerHTML;
    document.getElementById(cartId.value+"quantity").innerHTML = Number(prQuantity) - 1
    var prQuantity = document.getElementById(cartId.value+"quantity").innerHTML;
    var price = document.getElementById(cartId.value+"unitprice").innerHTML;
    var tax = document.getElementById(cartId.value+"unittax").innerHTML;
    var totalprice = document.getElementById("totalprice").innerHTML;
    var totaltax = document.getElementById("totaltax").innerHTML;
    var totalamount = document.getElementById("totalamount").innerHTML;
    document.getElementById("totalprice").innerHTML = Number(totalprice) - Number(price);
    document.getElementById("totaltax").innerHTML = Number(totaltax) - Number(tax);
    document.getElementById("totalamount").innerHTML = (Number(totalamount) - Number(tax)) - Number(price);
    if(prQuantity == 0){
        document.getElementById(cartId.value+"CartProduct").remove()
        var producttotalQuantity = document.getElementById("productQuantityId").innerHTML;
        document.getElementById("productQuantityId").innerHTML = Number(producttotalQuantity)-1;
        var producttotalQuantity = document.getElementById("productQuantityId").innerHTML;
        if(producttotalQuantity == 0){
            document.getElementById("cartPageMainId").innerHTML = 
                `<div class="d-flex justify-content-center">
                    <img src="../Assets/SiteImages/Empty_Shopping.jpg">
                </div>`
        }
    }
    $.ajax({
        type:"POST",
        url:"Component/userComponent.cfc?method=updateCartQuantity",
        data:{cartId:cartId.value,prQuantity:Number(prQuantity)}
    })
}

function removeCart(cartId){
    if(confirm("Are you sure to remove product from cart?")){
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
        document.getElementById("totalprice").innerHTML = Number(totalprice) - Number(qtyPrice)
        document.getElementById("totaltax").innerHTML = Number(totaltax) - Number(qtyTax)
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
            `<div class="d-flex justify-content-center">
                <img src="../Assets/SiteImages/Empty_Shopping.jpg">
            </div>`
        }
    }
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

function addressModalValidation(){
    var firstName = document.getElementById("firstNameId").value;
    var address1 = document.getElementById("address1Id").value;
    var city = document.getElementById("cityId").value;
    var state = document.getElementById("stateId").value;
    var pincode = document.getElementById("pincodeId").value;
    var phone = document.getElementById("phoneId").value;
    var phonePattern = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/;
    var flag = true;
    if(firstName.trim().length == 0){
        document.getElementById("firstWarning").innerHTML = "firstName is empty"
        document.getElementById("firstNameId").focus();
        document.getElementById("firstNameId").style.border = "2px solid red";
        flag = false;
    }else{
        document.getElementById("firstWarning").innerHTML = ""
        document.getElementById("firstNameId").style.border = "1px solid black";
    }

    if(address1 === ""){
        document.getElementById("address1Warning").innerHTML = "address line 1 is empty"
        document.getElementById("address1Id").focus();
        document.getElementById("address1Id").style.border = "2px solid red";
        flag = false;
    }else{
        document.getElementById("address1Warning").innerHTML = ""
        document.getElementById("address1Id").style.border = "1px solid black";
    }

    if(city === ""){
        document.getElementById("cityWarning").innerHTML = "city is empty"
        document.getElementById("cityId").focus();
        document.getElementById("cityId").style.border = "2px solid red";
        flag = false;
    }else{
        document.getElementById("cityWarning").innerHTML = ""
        document.getElementById("cityId").style.border = "1px solid black";
    }

    if(state === ""){
        document.getElementById("stateWarning").innerHTML = "state is empty"
        document.getElementById("stateId").focus();
        document.getElementById("stateId").style.border = "2px solid red";
        flag = false;
    }else{
        document.getElementById("stateWarning").innerHTML = ""
        document.getElementById("stateId").style.border = "1px solid black";
    }
    
    if(pincode.trim() === ""){
        document.getElementById("pincodeWarning").innerHTML = "pincode is empty";
        document.getElementById("pincodeId").focus();
        document.getElementById("pincodeId").style.border = "2px solid red";
        flag = false;
    }else{
        if(pincode.length !== 6){
            document.getElementById("pincodeWarning").innerHTML = "enter 6 digit pincode";
            flag = false;
        }else if(/^[0-9]{6}$/.test(pincode) === false){
            document.getElementById("pincodeWarning").innerHTML = "pincode should only contain digits";
            flag = false;
        }else{
            document.getElementById("pincodeWarning").innerHTML = "";
            document.getElementById("pincodeId").style.border = "1px solid black";
        }
    }

    if(phone === ""){
        document.getElementById("phoneWarning").innerHTML = "Phone Number is empty"
        document.getElementById("phoneId").focus();
        document.getElementById("phoneId").style.border = "2px solid red";
        flag = false;
    }else{
        if(!phonePattern.test(phone)){
            document.getElementById("phoneWarning").innerHTML = "Phone Number should follow pattern"
            flag = false;
        }else{
            document.getElementById("phoneWarning").innerHTML = ""
            document.getElementById("phoneId").style.border = "1px solid black";
        }
    }
    if(flag == false){
        event.preventDefault()
    }
    return flag;
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
    if(confirm("Confirm to remove address")){
        $.ajax({
            type:"POST",
            url:"Component/userComponent.cfc?method=deleteAddress",
            data:{addressId:addressId.value},
            success:function(){
                    document.getElementById(addressId.value+"address").remove();
                }
        })
    }
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
                    }else{
                        alert("User already exists")
                    }
                }
        })
    }
}

function loadAllProducts(productsIdArray){
    $.ajax({
        type:"POST",
        url:"Component/userComponent.cfc?method=loadMoreData",
        data:{productIdList:productsIdArray},
        success:function(result){
            var result = JSON.parse(result)
            for(j=0;j<result.length;j++){
                var eachProducts = 
                `<div class="card randomProductCard" style="width: 13rem;">
                    <a href="./productPage.cfm?productId=${result[j].fldProduct_ID}">
                        <img src="../Assets/ProductImages/${result[j].fldImageFileName}" class="card-img-top randProductImage" alt="Product Image">
                    </a>
                    <div class="card-body randProductbody">
                        <div class="card-text randProductName">${result[j].fldProductName}</div>
                        <div>${result[j].fldBrandName}</div>
                        <div class="card-text randProductPrice">
                            <i class="fa-solid fa-indian-rupee-sign"></i>
                            ${result[j].fldPrice + result[j].fldTax}
                        </div>
                    </div>
                </div>`
                $("#randomProductsMainDivId").append(eachProducts);
            }
            document.getElementById("viewMore").remove();
        }
    })
}

function verifyCard(cardData){
    const cardDataArray = cardData.value.split(",")
    var cardNumber = document.getElementById("cardNumberId").value;
    var cardMonth = document.getElementById("cardMonthId").value;
    var cardYear = document.getElementById("cardYearId").value;
    var cardCvv = document.getElementById("cardCvvId").value;
    var totalAmount = document.getElementById("totalAmount").innerHTML
    var flag = true;
    var error = ""
    if(cardNumber !== cardDataArray[0]){
        flag = false;
        error = "Card Number is wrong"
    }
    if((cardMonth !== cardDataArray[1])&&(flag == true)){
        flag = false;
        error = "Validity month is wrong"
    }
    if((cardYear !== cardDataArray[2]&&(flag == true))){
        flag = false;
        error = "Validity year is wrong"
    }
    if((cardCvv !== cardDataArray[3]&&(flag == true))){
        flag = false;
        error = "Card CVV is wrong"
    }
    if(flag == true){
        document.getElementById("cardWarningId").innerHTML = '<i class="fa-solid fa-check"></i> Verified'
        document.getElementById("cardWarningId").classList.add("text-success");
        document.getElementById("cardWarningId").classList.remove("text-danger");
        document.getElementById("placeOrderButtonId").disabled = false;
        document.getElementById("cardNumberId").readOnly  = true;
        document.getElementById("cardMonthId").readOnly = true;
        document.getElementById("cardYearId").readOnly = true;
        document.getElementById("cardCvvId").readOnly = true;
        document.getElementById("verifyButtonId").remove();
        document.getElementById("paymentsAmount").innerHTML = "Rs."+ totalAmount;
    }else{
        document.getElementById("cardWarningId").innerHTML = '<i class="fa-solid fa-xmark"></i> Unverified'
        document.getElementById("cardWarningId").classList.add("text-danger");
        document.getElementById("cardWarningId").classList.remove("text-success");
        document.getElementById("placeOrderButtonId").disabled = true;
        Swal.fire(error);
    }
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
    document.getElementById("totalprice").innerHTML = Number(totalprice) + Number(unitPrice);
    document.getElementById("totaltax").innerHTML = Number(totaltax) + Number(unitTax);
    document.getElementById("totalAmount").innerHTML = Number(totalAmount) + Number(unitPrice) + Number(unitTax)
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
    document.getElementById("totalprice").innerHTML = Number(totalprice) - Number(unitPrice);
    document.getElementById("totaltax").innerHTML = Number(totaltax) - Number(unitTax);
    document.getElementById("totalAmount").innerHTML = Number(totalAmount) - Number(unitPrice) - Number(unitTax)
    document.getElementById("productQuanityHidden").value = Number(productQuantity);
    if(productQuantity == 1){
        document.getElementById("reduceQuantity").disabled = true;
    }
}

function placeOrderFunction(){
    if(document.getElementById("addressDetailsId").value == 0){
        alert('Add a delivery address to contitnue')
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
    document.getElementById("userFirstNameWarning").innerHTML = "";
    document.getElementById("userEmailWarning").innerHTML = "";
    document.getElementById("userPhoneWarning").innerHTML = "";

}

function searchOrder(){
    searchKeyWord = document.getElementById("searchOrderId").value;
    const container = document.getElementById("orderHistorymainDivId")
    const allElements = container.querySelectorAll("[id]");
    var dataDiv = Array.from(allElements).filter(item => item.id.includes(searchKeyWord));
    var falseDiv = Array.from(allElements).filter(item => !item.id.includes(searchKeyWord));
    if(dataDiv.length>0){
        for(i=0;i<=dataDiv.length;i++){
            console.log(dataDiv)
            $(dataDiv[i]).show();
        }
        for(i=0;i<=falseDiv.length;i++){
            $(falseDiv[i]).hide();
        }
    }
}

function downloadConfirmation(){
    if(confirm("Confirm to download")){
        alert("Invoice Downloaded successfully")
        return true;
    }else{
        return false;
    }
}

var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
  return new bootstrap.Tooltip(tooltipTriggerEl)
})

if ( window.history.replaceState ) {
    window.history.replaceState( null, null, window.location.href );
}


