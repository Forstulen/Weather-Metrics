//
//  defines.h
//  WeatherApp
//
//  Created by Romain Tholimet on 10/9/13.
//  Copyright (c) 2013 Romain Tholimet. All rights reserved.
//

#ifndef WeatherApp_defines_h
#define WeatherApp_defines_h

// Open Weather API Delay before requesting again
#define     WEATHER_API_DELAY_REQUEST   (60 * 60)
#define     WEATHER_REFRESH_INTERVAL    (60 * 30)
#define     WEATHER_CLOCK_INTERVAL      (60)

#define     WEATHER_CELSIUS_TO_FARENHEIT(X) (X * 9 / 5 + 32)
#define     WEATHER_CELSIUS_TO_KELVIN(X)    (X + 273.15f)


#define     WEATHER_LOCATION_DISTANCE   (1000)
#define     WEATHER_LOCATION_TIME_TO_WAIT_BEFORE_REFRESH    (5)

#define     WEATHER_ICON_DURATION   (0.5)
#define     WEATHER_ICON_RANGE_MIN  (0)
#define     WEATHER_ICON_RANGE_MAX  (5)

// Weather Cell

#define     WEATHER_LOCATION_CELL_WIDTH [[UIScreen mainScreen] bounds].size.width
#define     WEATHER_LOCATION_CELL_HEIGHT    (113)
#define     WEATHER_LOCATION_ROW_HEIGHT     (WEATHER_LOCATION_CELL_HEIGHT)

#define     WEATHER_LOCATION_CELL_TEMP_WIDTH    (80)
#define     WEATHER_LOCATION_CELL_TEMP_HEIGHT   (WEATHER_LOCATION_CELL_HEIGHT)

#define     WEATHER_LOCATION_CELL_CITY_WIDTH    (120)

#define     WEATHER_LOCATION_CELL_ICON_WIDTH    (60)
#define     WEATHER_LOCATION_CELL_ICON_HEIGHT    (60)

#define     WEATHER_LOCATION_CELL_CITY_PADDING  (5)

#define     WEATHER_LOCATION_CELL_CURRENT_ICON_WIDTH  (25)
#define     WEATHER_LOCATION_CELL_CURRENT_ICON_HEIGHT  (WEATHER_LOCATION_CELL_HEIGHT)

static NSString   *WEATHER_CURRENT_LOCATION_IMAGE = @"current_location_icon.png";

// Weather Table View

#define     WEATHER_TABLE_VIEW_TOP_BAR_HEIGHT   (57)
#define     WEATHER_TABLE_VIEW_TOP_BAR_WIDTH    [[UIScreen mainScreen] bounds].size.width

// Weather  Graph

#define     WEATHER_GRAPH_CIRCLE_DIAMETER       (13)
#define     WEATHER_GRAPH_LINE_THICKNESS        (3)
#define     WEATHER_GRAPH_PADDING               (55)
#define     WEATHER_GRAPH_LABEL_TOP_PADDING     (10)

// Notification or Sentences

static NSString   *WEATHER_APP_ID = @"d944558995e9e4c990a10c9abee19492";
static NSString   *WEATHER_SAVE_NAME = @"weatherLocations";

static NSString   *WEATHER_ROOT_LOADING = @"Loading existing locations";

static NSString   *WEATHER_GRAPH_VIEW_NOT_LOADED = @"Forecast is not available";

static NSString   *WEATHER_LOCATION_WARNING_TITLE = @"The length of the name should be at least 3 characters";
static NSString   *WEATHER_LOCATION_WARNING_BUTTON_TITLE = @"Ok";
static NSString   *WEATHER_LOCATION_ALERT_VALIDATE_BUTTON_TITLE = @"Ok";
static NSString   *WEATHER_LOCATION_ALERT_CANCEL_BUTTON_TITLE = @"Cancel";
static NSString   *WEATHER_LOCATION_ALERT_TITLE = @"Select a city";

static NSString   *WEATHER_LOCATION_ALERT_FAIL_TITLE = @"Weather Error";
static NSString   *WEATHER_LOCATION_ALERT_FAIL_MESSAGE = @"An error has occured. Check the name of the city or your network";
static NSString   *WEATHER_LOCATION_ALERT_FAIL_VALIDATE_BUTTON_TITLE = @"Ok";


static NSString   *WEATHER_LOCATION_HEADER_TABLE_VIEW = @"Edit";

static NSString   *WEATHER_LOCATION_FONT = @"Avenir-Light";
static NSString   *WEATHER_LOCATION_FONT_NUMBER = @"HelveticaNeue-Light";
static NSString   *WEATHER_GRAPH_FONT = @"HelveticaNeue-Bold";

static NSString   *WEATHER_LOCATION_UPDATED = @"locationUpdated";
static NSString   *WEATHER_LOCATION_NEW = @"newLocation";
static NSString   *WEATHER_LOCATION_FAILED = @"failedLocation";
static NSString   *WEATHER_LOCATIONS_UP_TO_DATE_WITH_CURRENT_LOCATION = @"locationsUpToDateWithCurrentLocation";
static NSString   *WEATHER_LOCATIONS_UP_TO_DATE = @"locationsUpToDate";
static NSString   *WEATHER_LOCATION_SHOW_LIST = @"showList";
static NSString   *WEATHER_LOCATION_SHOW_PAGE = @"showPage";
static NSString   *WEATHER_LOCATION_ERROR_TEMP = @"- -";
static NSString   *WEATHER_LOCATION_ERROR_CITY = @"Nowhere";
static NSString   *WEATHER_LOCATION_FORECAST_ERROR = @"Forecast Error";

static NSString   *WEATHER_LOCATION_GRAPH_HINT = @"Hour Forecast";
// Weather Color


#define     WEATHER_WHITE_COLOR                 [UIColor whiteColor]
#define     WEATHER_HUMIDITY_BLUE_COLOR         [UIColor colorWithRed:(19.f / 255.f) green:(178.f / 255.f) blue:(234.f / 255.f) alpha:1]
#define     WEATHER_DARK_GREY_BAR_COLOR         [UIColor colorWithRed:(35.f / 255.f) green:(35.f / 255.f) blue:(35.f / 255.f) alpha:1]
#define     WEATHER_BLACK_HIGHLIGHT_BAR_COLOR   [UIColor colorWithRed:(51.f / 255.f) green:(51.f / 255.f) blue:(51.f / 255.f) alpha:1]
#define     WEATHER_LIGH_GREY_BG_COLOR          [UIColor colorWithRed:(198.f / 255.f) green:(198.f / 255.f) blue:(198.f / 255.f) alpha:1]
#define     WEATHER_MEDIUM_GREY_HIGHLIGHT_COLOR   [UIColor colorWithRed:(170.f / 255.f) green:(170.f / 255.f) blue:(170.f / 255.f) alpha:1]
#define     WEATHER_GRAPH_LINE_COLOR       [UIColor colorWithRed:(251.f / 255.f) green:(87.f / 255.f) blue:(54.f / 255.f) alpha:1]
#define     WEATHER_ADD_CITY_BG_COLOR   [UIColor colorWithRed:(94.f / 255.f) green:(186.f / 255.f) blue:(143.f / 255.f) alpha:1]

// Weather add

static NSString     *WEATHER_ADD_CITY_IMAGE = @"new_city_icon.png";
static NSString     *WEATHER_LOCATION_CURRENT_SQUARE = @"current_square.png";

// Icon names (OpenWeatherFront)

static NSString     *WEATHER_CLEAR_DESCRIPTION = @"01";
static NSString     *WEATHER_FEW_CLOUDS_DESCRIPTION = @"02";
static NSString     *WEATHER_SCATTERED_CLOUDS_DESCRIPTION = @"03";
static NSString     *WEATHER_BROKEN_CLOUDS_DESCRIPTION = @"04";
static NSString     *WEATHER_SHOWER_RAIN_DESCRIPTION = @"09";
static NSString     *WEATHER_RAIN_DESCRIPTION = @"10";
static NSString     *WEATHER_THUNDERSTORM_DESCRIPTION = @"11";
static NSString     *WEATHER_SNOW_DESCRIPTION = @"13";
static NSString     *WEATHER_MIST_DESCRIPTION = @"50";

// Icon location

static NSString     *WEATHER_SUNNY_LOCATION = @"sunny";
static NSString     *WEATHER_CLOUDY_LOCATION = @"cloudy";
static NSString     *WEATHER_FOGGY_LOCATION = @"foggy";
static NSString     *WEATHER_PARTLY_CLOUDY_LOCATION = @"partly";
static NSString     *WEATHER_RAINY_LOCATION = @"rainy";
static NSString     *WEATHER_SNOWY_LOCATION = @"snowy";
static NSString     *WEATHER_THUNDERSTORM_LOCATION = @"thunderstorm";
static NSString     *WEATHER_WINDY_LOCATION = @"windy";
static NSString     *WEATHER_NIGHT_LOCATION = @"night";

static NSString     *WEATHER_ICON_FOLDER = @"Images";

#endif
