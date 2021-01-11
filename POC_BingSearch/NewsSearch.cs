using System;
using System.Collections.Generic;
using System.Text;
using System.Linq;
using Microsoft.Azure.CognitiveServices.Search.NewsSearch;
using Microsoft.Azure.CognitiveServices.Search.NewsSearch.Models;

namespace BingSearch
{
    public class NewsSearch
    {
        public void Search(string searchTerm)
        {
            var client = new NewsSearchClient(new ApiKeyServiceClientCredentials(SubscriptionKey.getBingSearchKey()));
            News newsResults = client.News.SearchAsync(query: searchTerm, market: "en-us", count: 10).Result;

            if (newsResults.Value.Count > 0)
            {
                var firstNewsResult = newsResults.Value[0];

                Console.WriteLine($"TotalEstimatedMatches value: {newsResults.TotalEstimatedMatches}");
                Console.WriteLine($"News result count: {newsResults.Value.Count}");
                Console.WriteLine($"First news name: {firstNewsResult.Name}");
                Console.WriteLine($"First news url: {firstNewsResult.Url}");
                Console.WriteLine($"First news description: {firstNewsResult.Description}");
                Console.WriteLine($"First news published time: {firstNewsResult.DatePublished}");
                Console.WriteLine($"First news provider: {firstNewsResult.Provider[0].Name}");
            }

            else
            {
                Console.WriteLine("Couldn't find news results!");
            }
            Console.WriteLine("Enter any key to exit...");
            Console.ReadKey();
        }
    }
}
