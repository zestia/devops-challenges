# Ensure that the required dependencies are installed.
# You can install them using pip if they are not already installed.
# Make sure you run this in your terminal before executing the script.
# pip install requests

import requests
import csv

# Define the URL of the REST Countries API
api_url = "https://restcountries.com/v3.1/all"

# Send an HTTP GET request to the API
response = requests.get(api_url)

# Check if the request was successful
if response.status_code == 200:
    # Parse the JSON data from the response
    countries_data = response.json()

    # Define the CSV file name
    csv_file = "countries.csv"

    # Open the CSV file for writing
    with open(csv_file, mode="w", newline="") as file:
        writer = csv.writer(file)
        
        # Write the CSV header
        writer.writerow(["Country Name", "Capital City", "Region", "Population Size", "Number of Currencies", "Number of Languages"])

        # Initialize variables for statistics
        largest_population = 0
        most_currencies = 0
        most_languages = 0
        regions_count = {}

        # Iterate through the countries data
        for country in countries_data:
            country_name = country.get("name", "")
            capital = country.get("capital", "")
            region = country.get("region", "")
            population = country.get("population", 0)
            currencies = len(country.get("currencies", []))
            languages = len(country.get("languages", []))

            # Write the country data to the CSV file
            writer.writerow([country_name, capital, region, population, currencies, languages])

            # Update statistics
            if population > largest_population:
                largest_population = population
                country_largest_population = country_name
            if currencies > most_currencies:
                most_currencies = currencies
                country_most_currencies = country_name
            if languages > most_languages:
                most_languages = languages
                country_most_languages = country_name

            # Update region count
            if region in regions_count:
                regions_count[region] += 1
            else:
                regions_count[region] = 1

        # Print the requested statistics
        # Print the country with the most currencies and languages
        #common name is used here as there are multiple verions or names
        print(f"Country with the largest population: {country_largest_population['common']} ({largest_population} people)")
        print(f"Country with the most currencies: {country_most_currencies['common']} ({most_currencies} currencies)")
        print(f"Country with the most languages: {country_most_languages['common']} ({most_languages} languages)")
        print("Count of countries per region:")
        for region, count in regions_count.items():
            print(f"{region}: {count} countries")

    print(f"Data has been written to {csv_file}")
else:
    print(f"Failed to retrieve data from the API. Status code: {response.status_code}")

