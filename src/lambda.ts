import main from './index';

import { Handler } from 'aws-lambda';

interface Event {
  message: string
}

export const handler: Handler<Event, null> = (event, context) => {
  console.log(context.functionName);
  main(event);
};

