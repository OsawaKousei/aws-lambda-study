export const lambda_handler = async (event: any, context: any) => {
  const responseMessage = `Hello World!`;

  return {
    statusCode: 200,
    body: JSON.stringify({ message: responseMessage }),
  };
};
