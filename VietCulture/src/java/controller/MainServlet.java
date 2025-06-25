package controller;

import dao.RegionDAO;
import model.Region;
import model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet chính xử lý trang home và các trang có form regions
 */
@WebServlet(name = "MainServlet", urlPatterns = {
    "/",
    "/home",
    "/index",})
public class MainServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(MainServlet.class.getName());
    private RegionDAO regionDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        try {
            regionDAO = new RegionDAO();
            LOGGER.info("MainServlet initialized successfully");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Failed to initialize MainServlet", e);
            throw new ServletException("Initialization failed", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String servletPath = request.getServletPath();
        LOGGER.info("Processing GET request for: " + servletPath);

        try {
            // Load regions cho tất cả các trang
            loadRegions(request);

            // Load additional data based on path
            loadAdditionalData(request, servletPath);

            // Forward to appropriate JSP
            String jspPath = determineJSPPath(servletPath);
            LOGGER.info("Forwarding to: " + jspPath);

            request.getRequestDispatcher(jspPath).forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing request for " + servletPath, e);
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/view/jsp/error.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Handle form submissions
        String servletPath = request.getServletPath();
        LOGGER.info("Processing POST request for: " + servletPath);

        try {
            // Load regions again for form redisplay
            loadRegions(request);

            // Process form data
            processFormSubmission(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing POST request", e);
            loadRegions(request); // Reload for error display
            request.setAttribute("error", "Có lỗi xảy ra khi xử lý form: " + e.getMessage());

            String jspPath = determineJSPPath(servletPath);
            request.getRequestDispatcher(jspPath).forward(request, response);
        }
    }

    /**
     * Load regions from database - ALWAYS called
     */
    private void loadRegions(HttpServletRequest request) {
        List<Region> regions = new ArrayList<>();
        String debugInfo = "";

        try {
            LOGGER.info("Loading regions from database...");

            regions = regionDAO.getAllRegions();

            if (regions != null && !regions.isEmpty()) {
                LOGGER.info("✅ Successfully loaded " + regions.size() + " regions");

                // Log each region for debugging
                for (Region region : regions) {
                    LOGGER.info(String.format("Region: ID=%d, Name=%s, Vietnamese=%s",
                            region.getRegionId(), region.getName(), region.getVietnameseName()));
                }

                debugInfo = String.format("Loaded %d regions successfully from database", regions.size());
            } else {
                LOGGER.warning("⚠️ No regions found in database");
                debugInfo = "No regions found in database";
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "❌ Database error loading regions", e);
            debugInfo = "Database error: " + e.getMessage();

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "❌ Unexpected error loading regions", e);
            debugInfo = "System error: " + e.getMessage();
        }

        // ALWAYS set these attributes
        request.setAttribute("regions", regions);
        request.setAttribute("regionsCount", regions.size());
        request.setAttribute("regionDebugInfo", debugInfo);

        // Set success flag
        request.setAttribute("regionsLoaded", !regions.isEmpty());

        LOGGER.info(String.format("Set regions attribute: size=%d, isEmpty=%b",
                regions.size(), regions.isEmpty()));
    }

    /**
     * Load additional data based on page
     */
    private void loadAdditionalData(HttpServletRequest request, String servletPath) {
        try {
            switch (servletPath) {
                case "/":
                case "/home":
                case "/index":
                    // Load home page data
                    loadHomePageData(request);
                    break;

                case "/experiences":
                    // Load experiences data
                    loadExperiencesData(request);
                    break;

                case "/accommodations":
                    // Load accommodations data
                    loadAccommodationsData(request);
                    break;
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error loading additional data for " + servletPath, e);
        }
    }

    /**
     * Load home page specific data
     */
    private void loadHomePageData(HttpServletRequest request) {
        // TODO: Load categories, featured experiences, accommodations, reviews
        // For now, set empty lists to prevent JSP errors
        request.setAttribute("categories", new ArrayList<>());
        request.setAttribute("experiences", new ArrayList<>());
        request.setAttribute("accommodations", new ArrayList<>());
        request.setAttribute("reviews", new ArrayList<>());

        LOGGER.info("Home page data loaded (mock data)");
    }

    /**
     * Load experiences page data
     */
    private void loadExperiencesData(HttpServletRequest request) {
        // TODO: Load experiences from database
        request.setAttribute("experiences", new ArrayList<>());
        LOGGER.info("Experiences data loaded");
    }

    /**
     * Load accommodations page data
     */
    private void loadAccommodationsData(HttpServletRequest request) {
        // TODO: Load accommodations from database
        request.setAttribute("accommodations", new ArrayList<>());
        LOGGER.info("Accommodations data loaded");
    }

    /**
     * Process form submissions
     */
    private void processFormSubmission(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String regionId = request.getParameter("regionId");
        String action = request.getParameter("action");

        LOGGER.info("Processing form: regionId=" + regionId + ", action=" + action);

        // Validate
        if (regionId == null || regionId.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn miền");
            return;
        }

        // Process based on action
        if ("search".equals(action)) {
            // Handle search
            request.setAttribute("success", "Tìm kiếm cho miền ID: " + regionId);
        } else {
            // Default processing
            request.setAttribute("success", "Form đã được gửi thành công! Miền đã chọn: " + regionId);
        }
    }

    /**
     * Determine JSP path based on servlet path
     */
    private String determineJSPPath(String servletPath) {
        switch (servletPath) {
            case "/":
            case "/home":
            case "/index":
                return "/view/jsp/home/home.jsp";

            case "/experiences":
                return "/view/jsp/experiences.jsp";

            case "/accommodations":
                return "/view/jsp/accommodations.jsp";

            default:
                return "/view/jsp/home/home.jsp";
        }
    }
}
