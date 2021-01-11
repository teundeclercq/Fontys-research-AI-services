using System;
using System.Collections.Generic;
using System.Text;
using System.Linq;
using Microsoft.Azure.CognitiveServices.Search.VideoSearch;
using Microsoft.Azure.CognitiveServices.Search.VideoSearch.Models;

namespace BingSearch
{
    public class VideoSearch
    {
        public void SearchVideo(string query)
        {
            var client = new VideoSearchAPI(new ApiKeyServiceClientCredentials(SubscriptionKey.getBingSearchKey()));

            var videoResults = client.Videos.SearchAsync(query).Result;

            if (videoResults.Value.Count > 0)
            {
                var firstVideoResult = videoResults.Value[0];

                Console.WriteLine($"\r\nVideo result count: {videoResults.Value.Count}");
                Console.WriteLine($"First video id: {firstVideoResult.VideoId}");
                Console.WriteLine($"First video name: {firstVideoResult.Name}");
                Console.WriteLine($"First video url: {firstVideoResult.ContentUrl}");
            }
            else
            {
                Console.WriteLine("Couldn't find video results!");
            }
        }
    }
}
