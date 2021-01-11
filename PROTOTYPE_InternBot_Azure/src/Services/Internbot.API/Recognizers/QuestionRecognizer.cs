﻿using System;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.Bot.Builder;
using Microsoft.Bot.Builder.AI.Luis;
using Microsoft.Extensions.Configuration;

namespace Internbot.API.Recognizers
{
    public class QuestionRecognizer : IRecognizer
    {
        private readonly LuisRecognizer _recognizer;

        public QuestionRecognizer(IConfiguration configuration)
        {
            var luisIsConfigured = !string.IsNullOrEmpty(configuration["LuisAppId"]) && !string.IsNullOrEmpty(configuration["LuisEndpointKey"]) && !string.IsNullOrEmpty(configuration["LuisEndpointKey"]);
            if (luisIsConfigured)
            {
                var luisApplication = new LuisApplication(
                    configuration["LuisAppId"],
                    configuration["LuisEndpointKey"],
                    configuration["LuisEndpoint"]);

                var recognizerOptions = new LuisRecognizerOptionsV3(luisApplication)
                {
                    PredictionOptions = new Microsoft.Bot.Builder.AI.LuisV3.LuisPredictionOptions
                    {
                        IncludeInstanceData = true
                    }
                };

                _recognizer = new LuisRecognizer(recognizerOptions);
            }
        }

        public virtual bool IsConfigured => _recognizer != null;

        public async Task<RecognizerResult> RecognizeAsync(ITurnContext turnContext, CancellationToken cancellationToken)
            => await _recognizer.RecognizeAsync(turnContext, cancellationToken);

        public async Task<T> RecognizeAsync<T>(ITurnContext turnContext, CancellationToken cancellationToken)
            where T : IRecognizerConvert, new()
            => await _recognizer.RecognizeAsync<T>(turnContext, cancellationToken);
    }
}
