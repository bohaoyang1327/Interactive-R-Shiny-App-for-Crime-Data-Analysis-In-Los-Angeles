# Shiny Server iamge
FROM rocker/shiny:latest

# Install R（`project_shiny.R` ）
RUN R -e "install.packages(c('shiny', 'ggplot2', 'dplyr', 'leaflet', 'readxl', 'sf'), repos='https://cran.rstudio.com/')"

# Copy shiny app to docker
COPY . /srv/shiny-server/

RUN chown -R shiny:shiny /srv/shiny-server

EXPOSE 3838

# Shiny Server
CMD ["/usr/bin/shiny-server"]
