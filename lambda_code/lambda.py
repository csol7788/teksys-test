from datetime import datetime

def lambda_handler(event, context):
    today = datetime.today().date
    currenttime = datetime.now().time
    response = {
        "statusCode": 200,
        "body": {
            "Current_Date": str(today()),
            "Current_Time": str(currenttime())
        }
    }

    return response