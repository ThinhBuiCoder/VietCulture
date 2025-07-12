package com.chatbot.factory;

import com.chatbot.dao.TravelDAO;
import com.chatbot.service.*;
import com.chatbot.GeminiApiClient;
import com.chatbot.constants.ChatConstants;

/**
 * Factory class for creating and managing service instances
 * Implements basic dependency injection pattern
 */
public class ServiceFactory {
    
    private static ServiceFactory instance;
    private TravelDAO travelDAO;
    private GeminiApiClient geminiClient;
    
    // Service instances
    private WeatherService weatherService;
    private SearchService searchService;
    private GuideService guideService;
    private RecommendationService recommendationService;
    private CityService cityService;
    private ResponseGenerator responseGenerator;
    
    private ServiceFactory() {
        initializeCore();
        initializeServices();
    }
    
    public static synchronized ServiceFactory getInstance() {
        if (instance == null) {
            instance = new ServiceFactory();
        }
        return instance;
    }
    
    private void initializeCore() {
        this.travelDAO = new TravelDAO();
        this.geminiClient = new GeminiApiClient(ChatConstants.GEMINI_API_KEY);
    }
    
    private void initializeServices() {
        this.weatherService = new WeatherService();
        this.searchService = new SearchService(travelDAO);
        this.guideService = new GuideService();
        this.recommendationService = new RecommendationService(travelDAO, geminiClient);
        this.cityService = new CityService(travelDAO);
        this.responseGenerator = new ResponseGenerator(
            weatherService, searchService, guideService, 
            recommendationService, cityService, geminiClient
        );
    }
    
    // Getters for services
    public WeatherService getWeatherService() {
        return weatherService;
    }
    
    public SearchService getSearchService() {
        return searchService;
    }
    
    public GuideService getGuideService() {
        return guideService;
    }
    
    public RecommendationService getRecommendationService() {
        return recommendationService;
    }
    
    public CityService getCityService() {
        return cityService;
    }
    
    public ResponseGenerator getResponseGenerator() {
        return responseGenerator;
    }
    
    public TravelDAO getTravelDAO() {
        return travelDAO;
    }
    
    public GeminiApiClient getGeminiClient() {
        return geminiClient;
    }
    
    /**
     * Reset all services - useful for testing
     */
    public synchronized void reset() {
        instance = null;
    }
    
    /**
     * Set custom DAO for testing
     */
    public void setTravelDAO(TravelDAO travelDAO) {
        this.travelDAO = travelDAO;
        // Reinitialize services that depend on DAO
        this.searchService = new SearchService(travelDAO);
        this.recommendationService = new RecommendationService(travelDAO, geminiClient);
        this.cityService = new CityService(travelDAO);
        this.responseGenerator = new ResponseGenerator(
            weatherService, searchService, guideService, 
            recommendationService, cityService, geminiClient
        );
    }
    
    /**
     * Set custom Gemini client for testing
     */
    public void setGeminiClient(GeminiApiClient geminiClient) {
        this.geminiClient = geminiClient;
        // Reinitialize services that depend on Gemini
        this.recommendationService = new RecommendationService(travelDAO, geminiClient);
        this.responseGenerator = new ResponseGenerator(
            weatherService, searchService, guideService, 
            recommendationService, cityService, geminiClient
        );
    }
}