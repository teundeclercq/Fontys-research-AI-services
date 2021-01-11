using System;
using System.Collections.Generic;
using System.Text;
using System.Linq;
using Microsoft.Azure.CognitiveServices.Search.ImageSearch;
using Microsoft.Azure.CognitiveServices.Search.ImageSearch.Models;

namespace BingSearch
{
    public class ImageSearch
    {
        public void Search(string searchQuery)
        {
            string subscriptionKey = SubscriptionKey.getBingSearchKey();
            Images imageResults = null;
            string searchTerm = searchQuery;

            var client = new ImageSearchClient(new ApiKeyServiceClientCredentials(subscriptionKey));


            imageResults = client.Images.SearchAsync(query: searchTerm).Result; //search query

            if (imageResults != null)
            {
                /*//display the details for the first image result.
                var firstImageResult = imageResults.Value.First();
                Console.WriteLine($"\nTotal number of returned images: {imageResults.Value.Count}\n");
                Console.WriteLine($"Copy the following URLs to view these images on your browser.\n");
                Console.WriteLine($"URL to the first image:\n\n {firstImageResult.ContentUrl}\n");
                Console.WriteLine($"Thumbnail URL for the first image:\n\n {firstImageResult.ThumbnailUrl}");
                Console.ReadKey();*/

                Console.WriteLine($"\nTotal number of returned images: {imageResults.Value.Count}\n");

                foreach (var image in imageResults.Value)
                {
                    Console.WriteLine(image.ContentUrl);
                }
            }
        }
    }
}
