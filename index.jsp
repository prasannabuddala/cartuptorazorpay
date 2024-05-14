<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Products display</title>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<style>
body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }
        .navbar {
            background-color: #333;
            overflow: hidden;
            display: flex;
            align-items: center; /* Align items vertically */
            padding: 10px 20px;
        }
        .navbar a {
            color: #fff;
            text-decoration: none;
            font-size: 16px;
            padding: 10px;
        }
        .navbar a:hover {
            background-color: #555;
        }
        .cart-img {
            margin-left: auto; /* Push cart image to the right */
            width: 30px;
            height: auto;
        }

        #main {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-around;
            padding: 20px;
        }
        .box {
            width: 250px;
            height:250px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
            padding: 15px;
        }
        .box img {
            max-width: 100%;
            border-radius: 8px;
        }
        .box p {
            margin: 8px 0;
            font-size: 16px;
            color: #333;
        }
        .box button {
            background-color: #007bff;
            color: #fff;
            border: none;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .box button:hover {
            background-color: #0056b3;
        }
        button a{
        text-decoration: none;
        color: white;
        }
        #cat-price {
    display: flex;
    justify-content: space-around;
    align-items: center;
    margin-bottom: 20px;
}

#category-select, #price-select {
    margin-right: 20px;
}

#category-select label, #price-select label {
    font-weight: bold;
    margin-right: 10px;
}

#category-select select, #price-select select {
    padding: 8px;
    font-size: 16px;
    border-radius: 4px;
    border: 1px solid #ccc;
}

#category-select select {
    width: 150px;
}

#price-select select {
    width: 120px;
}
        
</style>
</head>
<body>
<div class="navbar">
    <div>
        <a href="#">Home</a>
        <a href="#">Products</a>
        <a href="#">About</a>
        <a href="#">Contact</a>
    </div>
    <img src="imgs/cart2.jpeg" alt="Cart" id="cartbtn" class="cart-img"/>
</div>
<h2 style="text-align:center">products</h2>
<div id="cat-price">
<div id="1"><label for="cat">choose from categories: </label><select id="cat" name="categories"></select></div>
<div id="2"><label for="price">choose based on price: <select id="price" name="pricee"><option value="50">below 50</option>
<option value="100">below 100</option>
<option value="150">below 150</option></select></div>
</div>
<div id="main">
</div>
</body>
<script type="text/javascript">
$(document).ready(function(){
	let allProducts = [];
	 function displayProducts(products) {
	        $("#main").empty(); 
	        $.each(products, function(ind, product){
	            let div = $("<div>");
	            div.attr("class","box");
	            //div.attr("id",product.pid);
	            let img = $("<img>");
	            img.attr("src",product.pimag);
	            img.attr({"width":"100px","height":"100px"})
	            let name = $("<p>");
	            name.html("<b>"+product.pname+"</b>");
	            let price = $("<p>");
	            price.text("Rs. "+product.pprice);
	            let btn = $("<button>");
				let a = $("<a>");
				a.attr("href","/cartmvc/AddToCartController?pid="+product.pid);
				a.text("add to cart");
				btn.append(a);
				div.append(img);
				div.append(name);
				div.append(price);
				div.append(btn);
				$("#main").append(div);
	        });
	    }
	$.ajax({
		url:"/cartmvc/GetProductCatController",
		method: "GET",
		dataType: "json",
		success: function(res){
			console.log(res);
			$.each(res,function(ind,category){
				let opt = $("<option>");
				opt.val(category.cat_id);
				opt.text(category.cat_name);
				$("select#cat").append(opt);
			})
		},
		error: function(xhr,s,err){
			console.log("error at fetching productcategories",err);
		}
	})
	$("select#cat").change(function(){
        var selectedCategoryId = $(this).val();
        filterProductsByCategory(selectedCategoryId);
    });
		$("select#price").change(function(){
			var selectedPrice = parseFloat($(this).val());
			console.log(selectedPrice);
	        filterProductsByPrice(selectedPrice);
	    });
	function filterProductsByPrice(price) {
        var filteredProducts = allProducts.filter(function(product) {
            return product.pprice <= price;
        });
        console.log(filteredProducts);
        displayProducts(filteredProducts);
    }
	 function filterProductsByCategory(categoryId) {
	        var filteredProducts = allProducts.filter(function(product) {
	            return product.pcatid == categoryId;
	        });
	        displayProducts(filteredProducts);
	    }
	$.ajax({
		url : "/cartmvc/GetProductsController",
		method: "GET",
		dataType: "json",
		success : function(res){
			allProducts = res;
			console.log(res);
            displayProducts(res); 
		},
		error: function(a,b,error){
			console.log(error);
		}
	})
	$("#cartbtn").click(function(){
		window.location.href = "cart.jsp";
	})
})
</script>
</html>