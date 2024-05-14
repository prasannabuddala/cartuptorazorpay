package servlets;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/RemoveCartItemController")
public class RemoveCartItemController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		int pid = Integer.parseInt(request.getParameter("pid"));
		System.out.println("gonna remove " + pid);
		List<CartItem> cartitems = (List<CartItem>) request.getSession().getAttribute("cartitems");
		for (int i = 0; i < cartitems.size(); i++) {
			CartItem item = cartitems.get(i);
			if (item.getPid() == pid) {
				cartitems.remove(i);
			}
		}
		request.getSession().setAttribute("cartitems", cartitems);
		response.setContentType("plain/text");
		response.getWriter().print("success");
	}

}
