import requests,os

# # Source: https://gist.githubusercontent.com/stellasphere/9490c195ed2b53c707087c8c2db4ec0c/raw/76b0cb0ef0bfd8a2ec988aa54e30ecd1b483495d/descriptions.json
# weatherCodes = {
#     "0": {
#       "day": {
#         "description": "Sunny",
#         "image": "http://openweathermap.org/img/wn/01d@2x.png"
#       },
#       "night": {
#         "description": "Clear",
#         "image": "http://openweathermap.org/img/wn/01n@2x.png"
#       }
#     },
#     "1": {
#       "day": {
#         "description": "Mainly Sunny",
#         "image": "http://openweathermap.org/img/wn/01d@2x.png"
#       },
#       "night": {
#         "description": "Mainly Clear",
#         "image": "http://openweathermap.org/img/wn/01n@2x.png"
#       }
#     },
#     "2": {
#       "day": {
#         "description": "Partly Cloudy",
#         "image": "http://openweathermap.org/img/wn/02d@2x.png"
#       },
#       "night": {
#         "description": "Partly Cloudy",
#         "image": "http://openweathermap.org/img/wn/02n@2x.png"
#       }
#     },
#     "3": {
#       "day": {
#         "description": "Cloudy",
#         "image": "http://openweathermap.org/img/wn/03d@2x.png"
#       },
#       "night": {
#         "description": "Cloudy",
#         "image": "http://openweathermap.org/img/wn/03n@2x.png"
#       }
#     },
#     "45": {
#       "day": {
#         "description": "Foggy",
#         "image": "http://openweathermap.org/img/wn/50d@2x.png"
#       },
#       "night": {
#         "description": "Foggy",
#         "image": "http://openweathermap.org/img/wn/50n@2x.png"
#       }
#     },
#     "48": {
#       "day": {
#         "description": "Rime Fog",
#         "image": "http://openweathermap.org/img/wn/50d@2x.png"
#       },
#       "night": {
#         "description": "Rime Fog",
#         "image": "http://openweathermap.org/img/wn/50n@2x.png"
#       }
#     },
#     "51": {
#       "day": {
#         "description": "Light Drizzle",
#         "image": "http://openweathermap.org/img/wn/09d@2x.png"
#       },
#       "night": {
#         "description": "Light Drizzle",
#         "image": "http://openweathermap.org/img/wn/09n@2x.png"
#       }
#     },
#     "53": {
#       "day": {
#         "description": "Drizzle",
#         "image": "http://openweathermap.org/img/wn/09d@2x.png"
#       },
#       "night": {
#         "description": "Drizzle",
#         "image": "http://openweathermap.org/img/wn/09n@2x.png"
#       }
#     },
#     "55": {
#       "day": {
#         "description": "Heavy Drizzle",
#         "image": "http://openweathermap.org/img/wn/09d@2x.png"
#       },
#       "night": {
#         "description": "Heavy Drizzle",
#         "image": "http://openweathermap.org/img/wn/09n@2x.png"
#       }
#     },
#     "56": {
#       "day": {
#         "description": "Light Freezing Drizzle",
#         "image": "http://openweathermap.org/img/wn/09d@2x.png"
#       },
#       "night": {
#         "description": "Light Freezing Drizzle",
#         "image": "http://openweathermap.org/img/wn/09n@2x.png"
#       }
#     },
#     "57": {
#       "day": {
#         "description": "Freezing Drizzle",
#         "image": "http://openweathermap.org/img/wn/09d@2x.png"
#       },
#       "night": {
#         "description": "Freezing Drizzle",
#         "image": "http://openweathermap.org/img/wn/09n@2x.png"
#       }
#     },
#     "61": {
#       "day": {
#         "description": "Light Rain",
#         "image": "http://openweathermap.org/img/wn/10d@2x.png"
#       },
#       "night": {
#         "description": "Light Rain",
#         "image": "http://openweathermap.org/img/wn/10n@2x.png"
#       }
#     },
#     "63": {
#       "day": {
#         "description": "Rain",
#         "image": "http://openweathermap.org/img/wn/10d@2x.png"
#       },
#       "night": {
#         "description": "Rain",
#         "image": "http://openweathermap.org/img/wn/10n@2x.png"
#       }
#     },
#     "65": {
#       "day": {
#         "description": "Heavy Rain",
#         "image": "http://openweathermap.org/img/wn/10d@2x.png"
#       },
#       "night": {
#         "description": "Heavy Rain",
#         "image": "http://openweathermap.org/img/wn/10n@2x.png"
#       }
#     },
#     "66": {
#       "day": {
#         "description": "Light Freezing Rain",
#         "image": "http://openweathermap.org/img/wn/10d@2x.png"
#       },
#       "night": {
#         "description": "Light Freezing Rain",
#         "image": "http://openweathermap.org/img/wn/10n@2x.png"
#       }
#     },
#     "67": {
#       "day": {
#         "description": "Freezing Rain",
#         "image": "http://openweathermap.org/img/wn/10d@2x.png"
#       },
#       "night": {
#         "description": "Freezing Rain",
#         "image": "http://openweathermap.org/img/wn/10n@2x.png"
#       }
#     },
#     "71": {
#       "day": {
#         "description": "Light Snow",
#         "image": "http://openweathermap.org/img/wn/13d@2x.png"
#       },
#       "night": {
#         "description": "Light Snow",
#         "image": "http://openweathermap.org/img/wn/13n@2x.png"
#       }
#     },
#     "73": {
#       "day": {
#         "description": "Snow",
#         "image": "http://openweathermap.org/img/wn/13d@2x.png"
#       },
#       "night": {
#         "description": "Snow",
#         "image": "http://openweathermap.org/img/wn/13n@2x.png"
#       }
#     },
#     "75": {
#       "day": {
#         "description": "Heavy Snow",
#         "image": "http://openweathermap.org/img/wn/13d@2x.png"
#       },
#       "night": {
#         "description": "Heavy Snow",
#         "image": "http://openweathermap.org/img/wn/13n@2x.png"
#       }
#     },
#     "77": {
#       "day": {
#         "description": "Snow Grains",
#         "image": "http://openweathermap.org/img/wn/13d@2x.png"
#       },
#       "night": {
#         "description": "Snow Grains",
#         "image": "http://openweathermap.org/img/wn/13n@2x.png"
#       }
#     },
#     "80": {
#       "day": {
#         "description": "Light Showers",
#         "image": "http://openweathermap.org/img/wn/09d@2x.png"
#       },
#       "night": {
#         "description": "Light Showers",
#         "image": "http://openweathermap.org/img/wn/09n@2x.png"
#       }
#     },
#     "81": {
#       "day": {
#         "description": "Showers",
#         "image": "http://openweathermap.org/img/wn/09d@2x.png"
#       },
#       "night": {
#         "description": "Showers",
#         "image": "http://openweathermap.org/img/wn/09n@2x.png"
#       }
#     },
#     "82": {
#       "day": {
#         "description": "Heavy Showers",
#         "image": "http://openweathermap.org/img/wn/09d@2x.png"
#       },
#       "night": {
#         "description": "Heavy Showers",
#         "image": "http://openweathermap.org/img/wn/09n@2x.png"
#       }
#     },
#     "85": {
#       "day": {
#         "description": "Light Snow Showers",
#         "image": "http://openweathermap.org/img/wn/13d@2x.png"
#       },
#       "night": {
#         "description": "Light Snow Showers",
#         "image": "http://openweathermap.org/img/wn/13n@2x.png"
#       }
#     },
#     "86": {
#       "day": {
#         "description": "Snow Showers",
#         "image": "http://openweathermap.org/img/wn/13d@2x.png"
#       },
#       "night": {
#         "description": "Snow Showers",
#         "image": "http://openweathermap.org/img/wn/13n@2x.png"
#       }
#     },
#     "95": {
#       "day": {
#         "description": "Thunderstorm",
#         "image": "http://openweathermap.org/img/wn/11d@2x.png"
#       },
#       "night": {
#         "description": "Thunderstorm",
#         "image": "http://openweathermap.org/img/wn/11n@2x.png"
#       }
#     },
#     "96": {
#       "day": {
#         "description": "Light Thunderstorms With Hail",
#         "image": "http://openweathermap.org/img/wn/11d@2x.png"
#       },
#       "night": {
#         "description": "Light Thunderstorms With Hail",
#         "image": "http://openweathermap.org/img/wn/11n@2x.png"
#       }
#     },
#     "99": {
#       "day": {
#         "description": "Thunderstorm With Hail",
#         "image": "http://openweathermap.org/img/wn/11d@2x.png"
#       },
#       "night": {
#         "description": "Thunderstorm With Hail",
#         "image": "http://openweathermap.org/img/wn/11n@2x.png"
#       }
#     }
#   }

# path = r"C:\Users\User\OneDrive\Desktop\Weather Forecast\weather\assets\wc_images"
# # image format eg: wc_99_day.png
# for i in weatherCodes:
#     day_file = f"wc_{i}_day.png"
#     night_file = f"wc_{i}_night.png"
#     dayResponse = requests.get(weatherCodes[i]['day']['image'])
#     with open(os.path.join(path,day_file),"wb") as file:
#       for chunk in dayResponse.iter_content(100000):
#               file.write(chunk)

#     nightResponse = requests.get(weatherCodes[i]['night']['image'])
#     with open(os.path.join(path,night_file),"wb") as file:
#       for chunk in nightResponse.iter_content(100000):
#               file.write(chunk)
    
# Turn into relative path
local_codes = {
  "0": {
    "day": {
      "description": "Sunny",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_0_day.png"
    },
    "night": {
      "description": "Clear",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_0_night.png"
    }
  },
  "1": {
    "day": {
      "description": "Mainly Sunny",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_1_day.png"
    },
    "night": {
      "description": "Mainly Clear",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_1_night.png"
    }
  },
  "2": {
    "day": {
      "description": "Partly Cloudy",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_2_day.png"
    },
    "night": {
      "description": "Partly Cloudy",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_2_night.png"
    }
  },
  "3": {
    "day": {
      "description": "Cloudy",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_3_day.png"
    },
    "night": {
      "description": "Cloudy",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_3_night.png"
    }
  },
  "45": {
    "day": {
      "description": "Foggy",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_45_day.png"
    },
    "night": {
      "description": "Foggy",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_45_night.png"
    }
  },
  "48": {
    "day": {
      "description": "Rime Fog",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_48_day.png"
    },
    "night": {
      "description": "Rime Fog",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_48_night.png"
    }
  },
  "51": {
    "day": {
      "description": "Light Drizzle",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_51_day.png"
    },
    "night": {
      "description": "Light Drizzle",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_51_night.png"
    }
  },
  "53": {
    "day": {
      "description": "Drizzle",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_53_day.png"
    },
    "night": {
      "description": "Drizzle",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_53_night.png"
    }
  },
  "55": {
    "day": {
      "description": "Heavy Drizzle",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_55_day.png"
    },
    "night": {
      "description": "Heavy Drizzle",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_55_night.png"
    }
  },
  "56": {
    "day": {
      "description": "Light Freezing Drizzle",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_56_day.png"
    },
    "night": {
      "description": "Light Freezing Drizzle",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_56_night.png"
    }
  },
  "57": {
    "day": {
      "description": "Freezing Drizzle",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_57_day.png"
    },
    "night": {
      "description": "Freezing Drizzle",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_57_night.png"
    }
  },
  "61": {
    "day": {
      "description": "Light Rain",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_61_day.png"
    },
    "night": {
      "description": "Light Rain",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_61_night.png"
    }
  },
  "63": {
    "day": {
      "description": "Rain",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_63_day.png"
    },
    "night": {
      "description": "Rain",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_63_night.png"
    }
  },
  "65": {
    "day": {
      "description": "Heavy Rain",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_65_day.png"
    },
    "night": {
      "description": "Heavy Rain",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_65_night.png"
    }
  },
  "66": {
    "day": {
      "description": "Light Freezing Rain",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_66_day.png"
    },
    "night": {
      "description": "Light Freezing Rain",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_66_night.png"
    }
  },
  "67": {
    "day": {
      "description": "Freezing Rain",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_67_day.png"
    },
    "night": {
      "description": "Freezing Rain",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_67_night.png"
    }
  },
  "71": {
    "day": {
      "description": "Light Snow",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_71_day.png"
    },
    "night": {
      "description": "Light Snow",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_71_night.png"
    }
  },
  "73": {
    "day": {
      "description": "Snow",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_73_day.png"
    },
    "night": {
      "description": "Snow",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_73_night.png"
    }
  },
  "75": {
    "day": {
      "description": "Heavy Snow",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_75_day.png"
    },
    "night": {
      "description": "Heavy Snow",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_75_night.png"
    }
  },
  "77": {
    "day": {
      "description": "Snow Grains",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_77_day.png"
    },
    "night": {
      "description": "Snow Grains",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_77_night.png"
    }
  },
  "80": {
    "day": {
      "description": "Light Showers",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_80_day.png"
    },
    "night": {
      "description": "Light Showers",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_80_night.png"
    }
  },
  "81": {
    "day": {
      "description": "Showers",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_81_day.png"
    },
    "night": {
      "description": "Showers",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_81_night.png"
    }
  },
  "82": {
    "day": {
      "description": "Heavy Showers",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_82_day.png"
    },
    "night": {
      "description": "Heavy Showers",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_82_night.png"
    }
  },
  "85": {
    "day": {
      "description": "Light Snow Showers",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_85_day.png"
    },
    "night": {
      "description": "Light Snow Showers",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_85_night.png"
    }
  },
  "86": {
    "day": {
      "description": "Snow Showers",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_86_day.png"
    },
    "night": {
      "description": "Snow Showers",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_86_night.png"
    }
  },
  "95": {
    "day": {
      "description": "Thunderstorm",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_95_day.png"
    },
    "night": {
      "description": "Thunderstorm",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_95_night.png"
    }
  },
  "96": {
    "day": {
      "description": "Light Thunderstorms With Hail",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_96_day.png"
    },
    "night": {
      "description": "Light Thunderstorms With Hail",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_96_night.png"
    }
  },
  "99": {
    "day": {
      "description": "Thunderstorm With Hail",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_99_day.png"
    },
    "night": {
      "description": "Thunderstorm With Hail",
      "image":
          "C:\\Users\\User\\OneDrive\\Desktop\\Weather Forecast\\weather\\assets\\wc_images\\wc_99_night.png"
    }
  }
}
new_local_codes = {}
for code in local_codes:
  for time in ["day","night"]:
      path = local_codes[code][time]["image"]
      new_path = "/".join(path.split("\\")[-2:])
      local_codes[code][time]["image"] = new_path
print(local_codes)
