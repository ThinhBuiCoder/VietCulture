package controller;

import dao.CityDAO;
import model.City;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.google.gson.Gson;

@WebServlet("/Travel/cities")
public class CityServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(CityServlet.class.getName());
    private CityDAO cityDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        cityDAO = new CityDAO();
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            List<City> cities = cityDAO.getAllCities();
            String jsonCities = gson.toJson(cities);
            PrintWriter out = response.getWriter();
            out.print(jsonCities);
            out.flush();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error retrieving cities", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving cities");
        }
    }
} 