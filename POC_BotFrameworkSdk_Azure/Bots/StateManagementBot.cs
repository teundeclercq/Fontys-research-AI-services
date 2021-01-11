using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Helpers;
using AdaptiveCards;
using Amazon.ElasticMapReduce.Model;
using Microsoft.Bot.Builder;
using Microsoft.Bot.Builder.Teams;
using Microsoft.Bot.Schema;
using Microsoft.Bot.Schema.Teams;
using Microsoft.Extensions.Configuration;
using Nancy.Json;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace TeamsConversationBot.Bots
{
    public class StateManagementBot : TeamsActivityHandler
    {
        private string _appId;
        private string _appPassword;
        private bool  IsNotChecked = false;
        private UserProfile userProfile;

        private BotState _conversationState;
        private BotState _userState;

        public StateManagementBot(ConversationState conversationState, UserState userState, IConfiguration config)
        {
            _conversationState = conversationState;
            _userState = userState;
            _appId = config["MicrosoftAppId"];
            _appPassword = config["MicrosoftAppPassword"];
        }

        protected override async Task OnMessageActivityAsync(ITurnContext<IMessageActivity> turnContext, CancellationToken cancellationToken)
        {
            // Get the state properties from the turn context.

            var conversationStateAccessors = _conversationState.CreateProperty<ConversationData>(nameof(ConversationData));
            var conversationData = await conversationStateAccessors.GetAsync(turnContext, () => new ConversationData());

            var userStateAccessors = _userState.CreateProperty<UserProfile>(nameof(UserProfile));
            userProfile = await userStateAccessors.GetAsync(turnContext, () => new UserProfile());

            if (string.IsNullOrEmpty(userProfile.Name))
            {
                // First time around this is set to false, so we will prompt user for name.
                if (conversationData.PromptedUserForName)
                {
                    // Set the name to what the user provided.
                    userProfile.Name = turnContext.Activity.Text?.Trim();

                    await turnContext.SendActivityAsync($"Nice too meet you, {userProfile.Name}");

                    //cards: courses of studentens en course informatie

                    await CardActivityAsync(turnContext, false, cancellationToken);

                    // Acknowledge that we got their name.
                    await turnContext.SendActivityAsync($"Thanks {userProfile.Name}. Select on the card which information you would like to see");


                    // Reset the flag to allow the bot to go through the cycle again.
                    conversationData.PromptedUserForName = false;
                }
                else
                {
                    // Prompt the user for their name.
                    await turnContext.SendActivityAsync($"Hello, I am TeamConversationBot!");
                    await turnContext.SendActivityAsync($"What is your name?");

                    // Set the flag to true, so we don't prompt in the next turn.
                    conversationData.PromptedUserForName = true;
                }
            }
            else
            {

                turnContext.Activity.RemoveRecipientMention();
                var text = turnContext.Activity.Text.Trim().ToLower();

                if(!IsNotChecked)
                {
                    if (text.Contains("courses"))
                    {
                        userProfile.status = "courses";
                        await GetAllCoursesAsync(turnContext, cancellationToken);
                        IsNotChecked = true;
                    }
                    else if (text.Contains("students"))
                    {
                        userProfile.status = "students";
                        await GetStudentsOfCoursesAsync(turnContext, cancellationToken);
                        IsNotChecked = true;
                    }
                    else if (text.Contains("single"))
                    {
                        userProfile.status = "single";
                        await GetSingleCoursesAsync(turnContext, cancellationToken);
                        IsNotChecked = true;
                    }
                }



                if (text.Contains("courseid"))
                    await GetCourseOrCoursesAsync(turnContext, cancellationToken);
                else if (text.Contains("userid"))
                    await GetCoursesAsync(turnContext, cancellationToken);
                else if (text.Contains("who"))
                    await GetSingleMemberAsync(turnContext, cancellationToken);
                else if (text.Contains("ok"))
                    await CallAPIAsync(turnContext, cancellationToken, userProfile);
                else if (text.Contains("show"))
                    await CardActivityAsync(turnContext, false, cancellationToken);
               

            }
        }

        public override async Task OnTurnAsync(ITurnContext turnContext, CancellationToken cancellationToken = default(CancellationToken))
        {
            await base.OnTurnAsync(turnContext, cancellationToken);

            // Save any state changes that might have occurred during the turn.
            await _conversationState.SaveChangesAsync(turnContext, false, cancellationToken);
            await _userState.SaveChangesAsync(turnContext, false, cancellationToken);
        }

        private async Task GetSingleCoursesAsync(ITurnContext<IMessageActivity> turnContext, CancellationToken cancellationToken)
        {

            try
            {
                var message_response = MessageFactory.Text(text: $"Would you please give your canvas CourseID?");

                var replyText = $"{turnContext.Activity.Text}, is that right?";
                await turnContext.SendActivitiesAsync(
                  new Activity[] {
                new Activity { Type = ActivityTypes.Typing },
                new Activity { Type = "delay", Value= 2000 },
                MessageFactory.Text(message_response.Text),
                  },
                  cancellationToken);
                await turnContext.SendActivityAsync(MessageFactory.Text($"Please write 'CourseID:' a front the numbers"));

            }
            catch (ErrorResponseException e)
            {
                if (e.Body.Error.Code.Equals("MemberNotFoundInConversation"))
                {
                    await turnContext.SendActivityAsync("Member not found.");
                    return;
                }
                else
                {
                    throw e;
                }
            }
        }

        private async Task GetStudentsOfCoursesAsync(ITurnContext<IMessageActivity> turnContext, CancellationToken cancellationToken)
        {

            try
            {
                var message_response = MessageFactory.Text(text: $"Would you please give your canvas CourseID?");

                var replyText = $"{turnContext.Activity.Text}, is that right?";
                await turnContext.SendActivitiesAsync(
                  new Activity[] {
                new Activity { Type = ActivityTypes.Typing },
                new Activity { Type = "delay", Value= 2000 },
                MessageFactory.Text(message_response.Text),
                  },
                  cancellationToken);
                await turnContext.SendActivityAsync(MessageFactory.Text($"Please write 'CourseID:' a front the numbers"));

            }
            catch (ErrorResponseException e)
            {
                if (e.Body.Error.Code.Equals("MemberNotFoundInConversation"))
                {
                    await turnContext.SendActivityAsync("Member not found.");
                    return;
                }
                else
                {
                    throw e;
                }
            }
        }

        private async Task GetCourseOrCoursesAsync(ITurnContext<IMessageActivity> turnContext, CancellationToken cancellationToken)
        {

            try

            {
                if (!string.IsNullOrEmpty(turnContext.Activity.Text))
                {
                    userProfile.courseID = turnContext.Activity.Text?.Trim();
                    var replyText = $"{turnContext.Activity.Text}, is that right?";
                    await turnContext.SendActivitiesAsync(
                      new Activity[] {
                new Activity { Type = ActivityTypes.Typing },
                new Activity { Type = "delay", Value= 2000 },
                MessageFactory.Text(replyText),
                      },
                      cancellationToken);
                }
                await turnContext.SendActivityAsync("Confirm by typing 'Ok'.");
            }

            catch (ErrorResponseException e)
            {
                if (e.Body.Error.Code.Equals("MemberNotFoundInConversation"))
                {
                    await turnContext.SendActivityAsync("Member not found.");
                    return;
                }
                else
                {
                    throw e;
                }
            }
        }

        private async Task GetAllCoursesAsync(ITurnContext<IMessageActivity> turnContext, CancellationToken cancellationToken)
        {

            try
            {

                var message_response = MessageFactory.Text(text: $"Would you please give your canvas UserID?");
                var replyText = $"{turnContext.Activity.Text}, is that right?";
                await turnContext.SendActivitiesAsync(
                  new Activity[] {
                new Activity { Type = ActivityTypes.Typing },
                new Activity { Type = "delay", Value= 2000 },
                MessageFactory.Text(message_response.Text),
                  },
                  cancellationToken);
                await turnContext.SendActivityAsync(MessageFactory.Text($"Please write 'UserID:' a front the numbers"));

            }
            catch (ErrorResponseException e)
            {
                if (e.Body.Error.Code.Equals("MemberNotFoundInConversation"))
                {
                    await turnContext.SendActivityAsync("Member not found.");
                    return;
                }
                else
                {
                    throw e;
                }
            }
        }

        private async Task GetCoursesAsync(ITurnContext<IMessageActivity> turnContext, CancellationToken cancellationToken)
        {

            try

            {
                if (!string.IsNullOrEmpty(turnContext.Activity.Text))
                {
                    userProfile.userID = turnContext.Activity.Text?.Trim();
                    var replyText = $"{turnContext.Activity.Text}, is that right?";
                    await turnContext.SendActivitiesAsync(
                      new Activity[] {
                new Activity { Type = ActivityTypes.Typing },
                new Activity { Type = "delay", Value= 2000 },
                MessageFactory.Text(replyText),
                      },
                      cancellationToken);
                }
                await turnContext.SendActivityAsync("Confirm by typing 'Ok'.");
            }

            catch (ErrorResponseException e)
            {
                if (e.Body.Error.Code.Equals("MemberNotFoundInConversation"))
                {
                    await turnContext.SendActivityAsync("Member not found.");
                    return;
                }
                else
                {
                    throw e;
                }
            }
        }

        private async Task CardActivityAsync(ITurnContext<IMessageActivity> turnContext, bool update, CancellationToken cancellationToken)
        {

            var card = new HeroCard
            {
                Buttons = new List<CardAction>
                        {
                            new CardAction
                            {
                                Type = ActionTypes.MessageBack,
                                Title = "All Courses",
                                Text = "courses"
                            },
                            new CardAction
                            {
                                Type = ActionTypes.MessageBack,
                                Title = "Students in my course",
                                Text = "students"
                            },
                            new CardAction
                            {
                                Type = ActionTypes.MessageBack,
                                Title = "Information of a course",
                                Text = "single"
                            }
                        }
            };


            if (update)
            {
                await SendUpdatedCard(turnContext, card, cancellationToken);
            }
            else
            {
                await SendWelcomeCard(turnContext, card, cancellationToken);
            }

        }

        private static async Task SendWelcomeCard(ITurnContext<IMessageActivity> turnContext, HeroCard card, CancellationToken cancellationToken)
        {
            var initialValue = new JObject { { "count", 0 } };
            card.Title = "Welcome!";
            card.Buttons.Add(new CardAction
            {
                Type = ActionTypes.MessageBack,
                Title = "Update Card",
                Text = "UpdateCardAction",
                Value = initialValue
            });

            var activity = MessageFactory.Attachment(card.ToAttachment());

            await turnContext.SendActivityAsync(activity, cancellationToken);
        }

        private static async Task SendUpdatedCard(ITurnContext<IMessageActivity> turnContext, HeroCard card, CancellationToken cancellationToken)
        {
            card.Title = "I've been updated";

            var data = turnContext.Activity.Value as JObject;
            data = JObject.FromObject(data);
            data["count"] = data["count"].Value<int>() + 1;
            card.Text = $"Update count - {data["count"].Value<int>()}";

            card.Buttons.Add(new CardAction
            {
                Type = ActionTypes.MessageBack,
                Title = "Update Card",
                Text = "UpdateCardAction",
                Value = data
            });

            var activity = MessageFactory.Attachment(card.ToAttachment());
            activity.Id = turnContext.Activity.ReplyToId;

            await turnContext.UpdateActivityAsync(activity, cancellationToken);
        }


        // api of courses
        private async Task CallAPIAsync(ITurnContext<IMessageActivity> turnContext, CancellationToken cancellationToken, UserProfile userProfile)
        {

            try
            {


                switch (userProfile.status)
                {
                    case "students":
                        await CallStudentsAsync(turnContext, cancellationToken);
                        break;
                    case "courses":
                        await CallCoursesAsync(turnContext, cancellationToken);
                        break;
                    case "single":
                        await CallCourseAsync(turnContext, cancellationToken);
                        break;
                    default:
                        break;

                }
            }
            catch (ErrorResponseException e)
            {
                if (e.Body.Error.Code.Equals("MemberNotFoundInConversation"))
                {
                    await turnContext.SendActivityAsync("Member not found.");
                    return;
                }
                else
                {
                    throw e;
                }
            }

        }

        // api of courses
        private async Task CallCoursesAsync(ITurnContext<IMessageActivity> turnContext, CancellationToken cancellationToken)
          {

                try
                {
                    int userid = Convert.ToInt32(userProfile.userID.Replace("UserID:", " ").Trim());
                    const string baseUrl = "https://fhict.instructure.com/api/v1/users/";
                    string url = baseUrl + userid + "/courses";
                    const string Token = "2464~H0sf6Yc7l95ndVXDF0eMpugSHcOSYVrlkDNfRm0PeyMjyi5BUADyAo6NCAeATGlS";
                    var response = GetReleases(url, Token);
                    List<JsonResponse> response_list = JsonConvert.DeserializeObject<List<JsonResponse>>(response);

                await turnContext.SendActivityAsync($"You have {response_list.Count} courses.");
                // await turnContext.SendActivityAsync($"all courses,{JsonConvert.SerializeObject(response_list)}");

                await turnContext.SendActivityAsync(response);
                    await turnContext.SendActivityAsync("Type 'show card', to see the cards");


                }

                catch (ErrorResponseException e)
                {
                    if (e.Body.Error.Code.Equals("MemberNotFoundInConversation"))
                    {
                        await turnContext.SendActivityAsync("Member not found.");
                        return;
                    }
                    else
                    {
                        throw e;
                    }
                }
            }

        // api of students
        private async Task CallStudentsAsync(ITurnContext<IMessageActivity> turnContext, CancellationToken cancellationToken)
        {

            try
            {

                int courseid = Convert.ToInt32(userProfile.courseID.Replace("CourseID:", " ").Trim());
                const string baseUrl = "https://fhict.instructure.com/api/v1/courses/";
                string url = baseUrl + courseid + "/students";
                const string Token = "2464~H0sf6Yc7l95ndVXDF0eMpugSHcOSYVrlkDNfRm0PeyMjyi5BUADyAo6NCAeATGlS";
                string response = GetReleases(url, Token);
                List<JsonResponse> response_list = JsonConvert.DeserializeObject<List<JsonResponse>>(response);

                await turnContext.SendActivityAsync($"There are {response_list.Count} students in your course.");
               // await turnContext.SendActivityAsync($"all information of the students,{JsonConvert.SerializeObject(response_list)}");

                await turnContext.SendActivityAsync("Type 'show card', to see the cards");

            }

            catch (ErrorResponseException e)
            {
                if (e.Body.Error.Code.Equals("MemberNotFoundInConversation"))
                {
                    await turnContext.SendActivityAsync("Member not found.");
                    return;
                }
                else
                {
                    throw e;
                }
            }
        }

        private async Task GetSingleMemberAsync(ITurnContext<IMessageActivity> turnContext, CancellationToken cancellationToken)
        {
            var member = new TeamsChannelAccount();

            try
            {
                member = await TeamsInfo.GetMemberAsync(turnContext, turnContext.Activity.From.Id, cancellationToken);
            }
            catch (ErrorResponseException e)
            {
                if (e.Body.Error.Code.Equals("MemberNotFoundInConversation"))
                {
                    await turnContext.SendActivityAsync("Member not found.");
                    return;
                }
                else
                {
                    throw e;
                }
            }

            var message = MessageFactory.Text($"You are: {member.Name}.");
            var res = await turnContext.SendActivityAsync(message);

        }



        // api of course
        private async Task CallCourseAsync(ITurnContext<IMessageActivity> turnContext, CancellationToken cancellationToken)
        {

            try
            {

                int courseid = Convert.ToInt32(userProfile.courseID.Replace("CourseID:"," ").Trim());

                const string baseUrl = "https://fhict.instructure.com/api/v1/courses/";
                string url = baseUrl + courseid;
                const string Token = "2464~H0sf6Yc7l95ndVXDF0eMpugSHcOSYVrlkDNfRm0PeyMjyi5BUADyAo6NCAeATGlS";
                var response = GetReleases(url, Token);
                JsonResponse response_ = JsonConvert.DeserializeObject<JsonResponse>(response);

                await turnContext.SendActivityAsync($"{JsonConvert.SerializeObject(response_)}");
                await turnContext.SendActivityAsync("Type 'show card', to see the cards");


            }

            catch (ErrorResponseException e)
            {
                if (e.Body.Error.Code.Equals("MemberNotFoundInConversation"))
                {
                    await turnContext.SendActivityAsync("Member not found.");
                    return;
                }
                else
                {
                    throw e;
                }
            }
        }

        // rest call  Authorization
        public string GetReleases(string url, string token)
        {
            using (var httpClient = new HttpClient())
            {
                httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
                string response = httpClient.GetStringAsync(new Uri(url)).Result;
                return response;
            }
        }

    }
}
