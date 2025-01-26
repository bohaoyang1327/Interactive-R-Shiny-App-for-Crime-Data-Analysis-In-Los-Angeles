[![Check Assignment](https://github.com/sta523-fa24/project-caramel_latte/workflows/Check%20Assignment/badge.svg)](https://github.com/sta523-fa24/project-caramel_latte/actions?query=workflow:%22Check%20Assignment%22)



-----------

This is the final project of Sta 523, implemented by caramel-latte team(Binqian Chai and Bohao Yang).

## About this Shiny App

The city of Los Angeles, a popular place for both domestic travelers and international tourists, offers endless attractions but also faces complex safety challenges. With safety being a crucial priority for both visitors and residents, crime analysis becomes the topic of interest. This project aims to be informative and is divided into two distinct parts: Exploratory Data Analysis (EDA) and an interactive Shiny app. We will use the Los Angeles Crime Data from Kaggle, focusing on the most relevant period from January to mid-April 2024. The found dataset is saved and uploaded as "crime2024.xlsx". The library "readxl" is used to load the data.

The first part focuses on Exploratory Data Analysis (EDA), where we analyze patterns in the found dataset to uncover meaningful insights about crime trends. By examining temporal, geographic, and demographic aspects of the data, the EDA reveals key patterns, such as which months and weekdays are associated with higher crime rates, the types of crimes most frequently reported, and how crime varies across different areas in Los Angeles. This analysis not only reveals the current trends but also provides actionable insights into potential contributing factors, such as seasonal activity, socioeconomic disparities, and urban characteristics.

The second part involves the creation of a Shiny app, aimed at providing users with an interactive platform to explore crime data in Los Angeles. The app is designed to help users make informed decisions about their travel and movement within the city by offering accessible, data-driven insights. Users can interact with a city map, which uses color-coded markers to represent crime density by area. Filters allow users to explore crime trends based on their selected date range, while bar charts display the top areas with the highest crime rates for comparison. A detailed table further enables users to investigate individual crime incidents, including the date, time, location, and type of crime. Together, these features provide a comprehensive and user-friendly tool for exploring crime patterns.

By combining EDA and the Shiny app, this project achieves a dual purpose: to analyze and interpret crime data for meaningful insights, and to provide an interactive platform that provides users with a deeper understanding of safety trends in Los Angeles. Through these efforts, we aim to enhance public awareness, support better decision-making, and contribute to a safer community.

---
## Variable Explanation

The following are the definitions or brief explanations of variables (column names in the dateset) that will be used inside the project.
1) DATE OCC: the date crime occurred in YYYY-MM-DD
2) TIME OCC: the time (in 24 hour military time) crime occurred
3) AREA NAME: the geographic area name in the city of Los Angeles that references a landmark or the surrounding community that the crime occurred
4) Part 1-2: crime severity with 1 referring to "serious" and 2 referring to "less serious"
5) Crm Cd Desc: a short phrase describing the crime (type)
6) Vict Descent: the descent of victims (The descent code will be explicitly definined in the Implementation section.)
7) Premis Desc: the type of location where the crime occurred
8) LAT: the specific latitude where the crime actually occurred
9) LON: the specific longitude where the crime actually occurred

---
## Implications
While this project focuses on Los Angeles, the methods and tools developed can be adapted for other cities and datasets. Expanding the temporal range, incorporating additional demographic and socioeconomic data, or integrating predictive analytics could further enhance crime analysis capabilities. Policymakers and law enforcement agencies could use these insights to design data-driven strategies, optimize resource allocation, and engage communities in crime prevention efforts.

Ultimately, our project shows the value of making crime data accessible and interactive. By providing users with intuitive tool and detailed insights, we aim to advocate a safer community and enhance the understanding of crime dynamics.

