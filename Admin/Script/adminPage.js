function adminLogin(){
    var adminuser = document.getElementById("adminUsername").value;
    var adminpassword = document.getElementById("adminPassword").value;
    var flag = true;
    if(adminuser.trim().length == 0){
        document.getElementById("userWarning").innerHTML = "enter username to login"
        flag = false;
    }else{
        document.getElementById("userWarning").innerHTML = ""
    }
    if(adminpassword.trim().length == 0){
        document.getElementById("passwordWarning").innerHTML = "enter password to login"
        flag = false;
    }else{
        document.getElementById("passwordWarning").innerHTML = ""
    }
    if(!flag){
        event.preventDefault();
    }
}

function categoryValidation(){
    var newcategory = document.getElementById("categoryId").value;
    var modalType = document.getElementById("categorySubmitButton").name;
    if(newcategory.trim().length == 0){
        document.getElementById("addcategoryWarning").innerHTML = "enter category name"
    }else if(modalType === "categoryCreateSubmit"){
        $.ajax({
            type:"POST",
            data:{newCategory:newcategory},
            url:"Component/adminComponent.cfc?method=insertCategories",
            success:function(result){
                result = JSON.parse(result)
                if(result == true){
                    alert("Same Category Exists")
                }else{
                    location.reload()
                }
            }
        })
    }else{
        var categoryId = document.getElementById("categorySubmitButton").value
        $.ajax({
            type:"POST",
            url:"Component/adminComponent.cfc?method=editCategory",
            data:{categoryId:categoryId,newcategory:newcategory},
            success:function(result){
                result = JSON.parse(result)
                if(result == true){
                    alert("Same Category Exists")
                }else{
                    location.reload()
                }
            }
        })
    }
}

function subCategoryValidation(){
    var newsubCategory = document.getElementById("subCategoryId").value;
    if(newsubCategory.trim().length == 0){
        document.getElementById("addcategoryWarning").innerHTML = "enter Sub-Category name"
        return false;
    }else{
        var categoryId = document.getElementById("categorySubmitButton").value
        $.ajax({
            type:"POST",
            url:"Component/adminComponent.cfc?method=addSubCategory",
            data:{categoryId:categoryId,newsubCategory:newsubCategory},
            success:function(result){
                result = JSON.parse(result)
                if(result == true){
                    alert("Same Sub-category Exists")
                }else{
                    location.reload()
                }
            }
        })
    }
}

function validateSubcate(){
    var newsubcategory = document.getElementById("editSubCategoryId").value
    if(newsubcategory.trim().length == 0){
        document.getElementById("addDiffcategoryWarning").innerHTML = "enter Sub-Category name"
        return false;
    }else{
        return true;
    }
}

function closeAdminModal(){
    document.getElementById("adminProductForm").reset();
}

function deleteCategory(categoryId){
    if(confirm("Confirm to delete")){
        $.ajax({
            type:"POST",
            url:"Component/adminComponent.cfc?method=deleteCategory",
            data:{categoryId:categoryId.value},
            success:function(){
                    location.reload()
                }
        })
    }
}


function logout(){
    if(confirm("Confirm to logout")){
        $.ajax({
            type:"POST",
            url:"Component/adminComponent.cfc?method=adminLogout",
            success:function(){
                    location.reload()
            }
        })
    }
}

function createCategory(){
    document.getElementById("staticBackdropLabel").innerHTML = "Add new Category";
    document.getElementById("categorySubmitButton").name = "categoryCreateSubmit"
    document.getElementById("categoryId").value = "";
}

function editCategory(categoryId){
    document.getElementById("staticBackdropLabel").innerHTML = "Edit Category";
    document.getElementById("categorySubmitButton").name = "categoryEditSubmit"
    document.getElementById("categorySubmitButton").value = categoryId.value;
    document.getElementById("categoryId").value = document.getElementById("categoryEdit"+categoryId.value).innerHTML
}

function editSubcategoryModal(subCategoryId,categoryId){
    var subCategoryName = document.getElementById(subCategoryId.value).innerHTML;
    document.getElementById("editSubCategoryId").value = subCategoryName;
    document.getElementById(categoryId+"Category").selected = true;
    document.getElementById("subcategorySubmitButton").value = subCategoryId.value;
    document.getElementById("addDiffcategoryWarning").innerHTML = "";
}


function deleteSubCategory(subcategoryId){
    if(confirm("Confirm to delete")){
        document.getElementById("eachSub"+subcategoryId.value).remove();
        $.ajax({
            type:"POST",
            url:"Component/adminComponent.cfc?method=deleteSubcategory",
            data:{subcategoryId:subcategoryId.value}

        })
    }
}

function deleteProduct(productId){
    if(confirm("Confirm to delete")){
        document.getElementById(productId.value+"product").remove();
        $.ajax({
            type:"POST",
            url:"Component/adminComponent.cfc?method=deleteproduct",
            data:{productId:productId.value}
        })
    }
}

function getSubCategoriesFunction(){
    var categoryId = document.getElementById("categoriesSelect").value;
    var subcategoriesSelect = document.getElementById("subcategoriesSelect");
    $.ajax({
        type:"POST",
        url:"Component/adminComponent.cfc?method=listAllSubcategories",
        data:{categoryId:categoryId},
        success:function(result){
            if(result)
            {
                subcategoryDetails=JSON.parse(result)
                while (subcategoriesSelect.options.length) {
                    subcategoriesSelect.remove(0);
                }
                for (var key in subcategoryDetails) {
                    if (subcategoryDetails.hasOwnProperty(key)) {
                      var option = document.createElement('option');
                      option.value = key; 
                      option.textContent = subcategoryDetails[key];
                      subcategoriesSelect.appendChild(option);
                    }
                }
            }
        }
    })
}

function openProductModal(categoryId,subcategoryId){
    document.getElementById("adminProductForm").reset();
    document.getElementById("staticBackdropLabel").innerHTML = "Add New Product"
    document.getElementById(categoryId+"cate").selected = true;
    document.getElementById(subcategoryId+"subcate").selected = true;
    document.getElementById("productSubmitButton").name = "productSubmit"
    document.getElementById("productImageId").required = true;
}

function updateProductFunction(productId,categoryId,subcategoryId){
    document.getElementById("staticBackdropLabel").innerHTML = "Edit Product"
    document.getElementById(categoryId+"cate").selected = true;
    document.getElementById(subcategoryId+"subcate").selected = true;
    $.ajax({
        type:"POST",
        url:"Component/adminComponent.cfc?method=getProducts",
        data:{subcategoryId:subcategoryId,jscall:true,productId:productId.value},
        success:function(result){
            var editData = JSON.parse(result)
            document.getElementById("productNameId").value = editData.productname
            document.getElementById(editData.brandid+"brand").selected = true;
            document.getElementById("productdescriptionId").value = editData.productdesc;
            document.getElementById("productPriceId").value = editData.productprice;
            document.getElementById("producttaxId").value = editData.fldtax;
            document.getElementById("productSubmitButton").name = "productEdit"
            document.getElementById("productSubmitButton").value = productId.value;
            document.getElementById("productImageId").required = false;
        }
    })
}

function addcarousalImage(productId){
    $.ajax({
        type:"POST",
        url:"Component/adminComponent.cfc?method=getProductImages",
        data:{productId:productId.value},
        success:function(result){
            productImages=JSON.parse(result)
            defaultKey=Object.keys(productImages.imageDefaultStruct)
            var sliderBody = document.createElement('div');
            var sliderImage = document.createElement('img');
            sliderBody.classList.add("carousel-item");
            sliderImage.src="../Assets/ProductImages/"+productImages.imageDefaultStruct[defaultKey];
            sliderImage.width=350;
            sliderImage.height=350;
            sliderBody.appendChild(sliderImage)
            sliderBody.classList.add("active");
            document.getElementById("carousel-inner").appendChild(sliderBody)
            for (var key in productImages.imageinnerStruct) {
                var sliderImage = document.createElement('img');
                var sliderBody = document.createElement('div');
                sliderBody.classList.add("carousel-item");
                sliderImage.src="../Assets/ProductImages/"+productImages.imageinnerStruct[key];
                sliderImage.width=350;
                sliderImage.height=350;
                sliderBody.appendChild(sliderImage);
                var deleteButton = document.createElement('button')
                deleteButton.classList.add("btn")
                deleteButton.classList.add("btn-danger")
                deleteButton.classList.add("mt-2")
                deleteButton.classList.add("w-25")
                deleteButton.type = "button"
                deleteButton.value = key;
                deleteButton.innerHTML = "Delete";
                deleteButton.id = key+"delete";
                deleteButton.onclick = function() {
                    deleteProductImage(this);
                };
                sliderBody.appendChild(deleteButton)
                var setDefaultButton = document.createElement('button')
                setDefaultButton.classList.add("btn")
                setDefaultButton.classList.add("btn-success")
                setDefaultButton.classList.add("w-50")
                setDefaultButton.value = key
                setDefaultButton.type = "button"
                setDefaultButton.innerHTML = "Set as Default";
                setDefaultButton.classList.add("mt-2")
                setDefaultButton.classList.add("ms-1")
                setDefaultButton.onclick = function() {
                    setDefaultImage(this,productId.value);
                };
                sliderBody.appendChild(setDefaultButton)
                document.getElementById("carousel-inner").appendChild(sliderBody)
            }
        }
    })
}

function deleteProductImage(imageId){
    if(confirm("Confirm to delete")){
        $.ajax({
            type:"POST",
            url:"Component/adminComponent.cfc?method=deleteProductImage",
            data:{imageId:imageId.value},
            success:function(){
                alert("Image Succesfully deleted");
                location.reload()
            }
        })
    }
}

function setDefaultImage(imageId,productId){
    $.ajax({
        type:"POST",
        url:"Component/adminComponent.cfc?method=setDefaultImage",
        data:{imageId:imageId.value,productId:productId},
        success:function(){
            location.reload()
        }
    })
}

function closeAdminImageModal(){
    document.getElementById("carousel-inner").innerHTML = ""
}

if ( window.history.replaceState ) {
    window.history.replaceState( null, null, window.location.href );
}
