$(document).click(()=>{
    $("#serverErrorSpan").hide()
})

function categoryValidation(){
    var newcategory = document.getElementById("categoryId").value;
    var modalType = document.getElementById("categorySubmitButton").name;
    if(newcategory.trim().length == 0){
        document.getElementById("addcategoryWarning").innerHTML = "enter category name"
    }else if(modalType === "categoryCreateSubmit"){
        $.ajax({
            type:"POST",
            data:{newcategory:newcategory},
            url:"Component/adminComponent.cfc?method=insertCategories",
            success:function(result){
                result = JSON.parse(result)
                if(result == true){
                    Swal.fire("Same Category Exists!");
                }else{
                    Swal.fire({
                        title: "Category Added",
                        confirmButtonText: "Okay",
                      }).then((result) => {
                        if (result.isConfirmed) {
                            location.reload()
                        }
                      });
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
                    Swal.fire("Same Category Exists!");
                }else{
                    location.reload()
                }
            }
        })
    }
}

function warningClear(){
    document.getElementById("addcategoryWarning").innerHTML = ""
}

function closeAdminModal(){
    document.getElementById("adminProductForm").reset();
}

function deleteCategory(categoryId){
    Swal.fire({
        title: "Confirm to delete Category",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Confirm!"
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                type:"POST",
                url:"Component/adminComponent.cfc?method=deleteCategory",
                data:{categoryId:categoryId.value},
                success:function(){
                        location.reload()
                    }
            })
        }
    });
}



function logout(){
    Swal.fire({
        title: "Confirm to logout",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Confirm!"
    }).then((result) => {
        if (result.isConfirmed) {
            $.ajax({
                type:"POST",
                url:"Component/adminComponent.cfc?method=adminLogout",
                success:function(){
                        location.reload()
                }
            })
        }
    });
}

function createCategory(){
    document.getElementById("staticBackdropLabel").innerHTML = "Add new Category";
    document.getElementById("categorySubmitButton").name = "categoryCreateSubmit"
    document.getElementById("addcategoryWarning").innerHTML = ""
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
    Swal.fire({
        title: "Confirm to delete subCategory",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Confirm!"
    }).then((result) => {
        if (result.isConfirmed) {
            document.getElementById("eachSub"+subcategoryId.value).remove();
            $.ajax({
                type:"POST",
                url:"Component/adminComponent.cfc?method=deleteSubcategory",
                data:{subcategoryId:subcategoryId.value}

            })
        }
    });
}

function deleteProduct(productId){
    Swal.fire({
        title: "Confirm to delete product",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Confirm!"
    }).then((result) => {
        if (result.isConfirmed) {
            document.getElementById(productId.value+"product").remove();
            $.ajax({
                type:"POST",
                url:"Component/adminComponent.cfc?method=deleteproduct",
                data:{productId:productId.value}
            })
        }
    });
}

function getSubCategoriesFunction(){
    var categoryId = document.getElementById("categoriesSelect").value;
    var subcategoriesSelect = document.getElementById("subcategoriesSelect");
    $.ajax({
        type:"POST",
        url:"Component/adminComponent.cfc?method=listSubcategories",
        data:{categoryId:categoryId,returnStruct:"true"},
        success:function(result){
            if(result)
            {
                subcategoryDetails=JSON.parse(result)
                while (subcategoriesSelect.options.length){
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
        data:{subcategoryId:subcategoryId,returnStruct:true,productId:productId.value},
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
            sliderImage.width=400;
            sliderImage.height=400;
            sliderImage.classList.add("sliderImage")
            sliderBody.appendChild(sliderImage)
            sliderBody.classList.add("active");
            var activeImage = document.createElement('button')
            activeImage.classList.add("btn")
            activeImage.classList.add("btn-success")
            activeImage.classList.add("mt-2")
            activeImage.classList.add("w-100")
            activeImage.type = "button"
            activeImage.innerHTML = "THUMBNAIL";
            sliderBody.appendChild(activeImage)
            document.getElementById("carousel-inner").appendChild(sliderBody)
            for (var key in productImages.imageinnerStruct) {
                var sliderImage = document.createElement('img');
                var sliderBody = document.createElement('div');
                sliderBody.classList.add("carousel-item");
                sliderImage.src="../Assets/ProductImages/"+productImages.imageinnerStruct[key];
                sliderImage.width=400;
                sliderImage.height=400;
                sliderImage.classList.add("sliderImage")
                sliderBody.appendChild(sliderImage);
                var deleteButton = document.createElement('button')
                deleteButton.classList.add("btn")
                deleteButton.classList.add("btn-danger")
                deleteButton.classList.add("mt-2")
                deleteButton.classList.add("w-50")
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
                Swal.fire("Image Succesfully deleted!");
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

window.addEventListener('pageshow', (event) => {
    if (event.persisted) {
      window.location.reload();
    }
});


if ( window.history.replaceState ) {
    window.history.replaceState( null, null, window.location.href );
}
