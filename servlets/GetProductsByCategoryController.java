package servlets;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

@WebServlet("/GetProductsByCategoryController")
public class GetProductsByCategoryController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		int catid = Integer.parseInt(request.getParameter("categoryId"));
		GetProductsDAL obj = new GetProductsDAL();
		List<Products> products = obj.getProductsByCat(catid);
		response.setContentType("application/json");
		PrintWriter pw = response.getWriter();
		Gson gson = new Gson();
		String json = gson.toJson(products);
		pw.println(json);
	}

}
