import json
import os
import boto3
import logging
from datetime import datetime
import requests
from typing import Dict, Any

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)

# Initialize DynamoDB client
dynamodb = boto3.resource('dynamodb')
table = dynamodb.Table(os.environ['DYNAMODB_TABLE'])

# LINE API configuration
LINE_API_URL = "https://api.line.me/v2/bot/message/broadcast"
LINE_HEADERS = {
    "Content-Type": "application/json",
    "Authorization": f"Bearer {os.environ['LINE_CHANNEL_TOKEN']}"
}

def format_product_message(product: Dict[str, Any]) -> str:
    """Format product information into a message string."""
    return (
        f"🆕 新商品が入荷されました！\n\n"
        f"📦 商品名: {product['name']}\n"
        f"🏷️ カテゴリ: {product['category']}\n"
        f"💰 価格: ¥{product['price']:,}\n"
    )

def send_line_notification(message: str) -> Dict[str, Any]:
    """Send notification to LINE."""
    try:
        payload = {
            "messages": [
                {
                    "type": "text",
                    "text": message
                }
            ]
        }
        
        response = requests.post(
            LINE_API_URL,
            headers=LINE_HEADERS,
            json=payload
        )
        response.raise_for_status()
        return {"success": True, "status_code": response.status_code}
        
    except requests.exceptions.RequestException as e:
        logger.error(f"Failed to send LINE notification: {str(e)}")
        return {"success": False, "error": str(e)}

def save_product(product_data: Dict[str, Any]) -> Dict[str, Any]:
    """Save product to DynamoDB."""
    try:
        # Add timestamp
        product_data['created_at'] = datetime.utcnow().isoformat()
        
        # Save to DynamoDB
        table.put_item(Item=product_data)
        return {"success": True, "product": product_data}
        
    except Exception as e:
        logger.error(f"Failed to save product to DynamoDB: {str(e)}")
        return {"success": False, "error": str(e)}

def handler(event, context):
    """Lambda handler function."""
    logger.info(f"Received event: {json.dumps(event)}")
    
    try:
        # Parse request body
        body = json.loads(event['body'])
        
        # Validate required fields
        required_fields = ['product_id', 'name', 'category', 'price']
        if not all(field in body for field in required_fields):
            return {
                'statusCode': 400,
                'body': json.dumps({
                    'error': 'Missing required fields',
                    'required_fields': required_fields
                })
            }
        
        # Save product to DynamoDB
        save_result = save_product(body)
        if not save_result['success']:
            return {
                'statusCode': 500,
                'body': json.dumps({
                    'error': 'Failed to save product',
                    'details': save_result['error']
                })
            }
        
        # Format and send LINE notification
        message = format_product_message(body)
        notification_result = send_line_notification(message)
        
        if not notification_result['success']:
            return {
                'statusCode': 500,
                'body': json.dumps({
                    'error': 'Failed to send LINE notification',
                    'details': notification_result['error']
                })
            }
        
        return {
            'statusCode': 200,
            'body': json.dumps({
                'message': 'Product saved and notification sent successfully',
                'product': save_result['product']
            })
        }
        
    except json.JSONDecodeError:
        return {
            'statusCode': 400,
            'body': json.dumps({
                'error': 'Invalid JSON in request body'
            })
        }
        
    except Exception as e:
        logger.error(f"Unexpected error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps({
                'error': 'Internal server error',
                'details': str(e)
            })
        }
