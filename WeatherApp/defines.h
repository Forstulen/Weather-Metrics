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
// Seconds
#define     WEATHER_API_DELAY_REQUEST   (60 * 60)

#define     WEATHER_CELSIUS_TO_FARENHEIT(X) (X * 9 / 5 + 32)

// Meters
#define     WEATHER_LOCATION_DISTANCE   (500)

#define     WEATHER_LOCATION_TIME_TO_WAIT_BEFORE_REFRESH    (5)

// Weather Cell

#define     WEATHER_LOCATION_CELL_WIDTH [[UIScreen mainScreen] bounds].size.width
#define     WEATHER_LOCATION_CELL_HEIGHT    (80)
#define     WEATHER_LOCATION_ROW_HEIGHT     (WEATHER_LOCATION_CELL_HEIGHT)

#define     WEATHER_LOCATION_CELL_TEMP_WIDTH    (20)
#define     WEATHER_LOCATION_CELL_TEMP_HEIGHT   (WEATHER_LOCATION_CELL_HEIGHT)

#define     WEATHER_LOCATION_CELL_CITY_WIDTH    (100)

#define     WEATHER_LOCATION_CELL_CITY_PADDING  (10)


static NSString   *WEATHER_APP_ID = @"d944558995e9e4c990a10c9abee19492";
static NSString   *WEATHER_SAVE_NAME = @"weatherLocations";

static NSString   *WEATHER_LOCATION_WARNING_TITLE = @"The lenght of the name should be at least 3 characters";
static NSString   *WEATHER_LOCATION_WARNING_BUTTON_TITLE = @"Ok";
static NSString   *WEATHER_LOCATION_ALERT_VALIDATE_BUTTON_TITLE = @"Ok";
static NSString   *WEATHER_LOCATION_ALERT_CANCEL_BUTTON_TITLE = @"Cancel";
static NSString   *WEATHER_LOCATION_ALERT_TITLE = @"Add a location";

static NSString   *WEATHER_LOCATION_HEADER_TABLE_VIEW = @"Edit";

static NSString   *WEATHER_LOCATION_FONT = @"Trebuchet MS";

static NSString   *WEATHER_LOCATION_UPDATED = @"locationUpdated";
static NSString   *WEATHER_LOCATION_NEW = @"newLocation";
static NSString   *WEATHER_LOCATIONS_UP_TO_DATE_WITH_CURRENT_LOCATION = @"locationsUpToDateWithCurrentLocation";
static NSString   *WEATHER_LOCATIONS_UP_TO_DATE = @"locationsUpToDate";
static NSString   *WEATHER_LOCATION_SHOW_LIST = @"showList";
static NSString   *WEATHER_LOCATION_SHOW_PAGE = @"showPage";




#endif
