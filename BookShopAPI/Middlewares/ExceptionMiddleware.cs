using System.Net;
using System.Text.Json;

namespace BookShopAPI.Middlewares
{
    public class ExceptionMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly ILogger<ExceptionMiddleware> _logger;
        private readonly IWebHostEnvironment _env;

        public ExceptionMiddleware(RequestDelegate next, ILogger<ExceptionMiddleware> logger, IWebHostEnvironment env)
        {
            _next = next;
            _logger = logger;
            _env = env;
        }

        public async Task InvokeAsync(HttpContext context)
        {
            try
            {
                await _next(context);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, ex.Message);
                await HandleExceptionAsync(context, ex);
            }
        }

        private Task HandleExceptionAsync(HttpContext context, Exception exception)
        {
            int statusCode;
            string errorType;
            string message = exception.Message;

            switch (exception)
            {
                case KeyNotFoundException:
                    statusCode = (int)HttpStatusCode.NotFound;
                    errorType = "NotFound";
                    break;

                case ArgumentException:
                    statusCode = (int)HttpStatusCode.BadRequest;
                    errorType = "ValidationError";
                    break;

                case InvalidOperationException:
                    statusCode = (int)HttpStatusCode.Conflict;
                    errorType = "Conflict";
                    break;

                case UnauthorizedAccessException:
                    statusCode = (int)HttpStatusCode.Unauthorized;
                    errorType = "Unauthorized";
                    break;

                default:
                    statusCode = (int)HttpStatusCode.InternalServerError;
                    errorType = "ServerError";
                    message = _env.IsDevelopment() ? exception.Message : "Something went wrong.";
                    break;
            }

            context.Response.ContentType = "application/json";
            context.Response.StatusCode = statusCode;

            var response = new
            {
                statusCode,
                errorType,
                message
            };

            return context.Response.WriteAsync(JsonSerializer.Serialize(response));
        }
    }
}