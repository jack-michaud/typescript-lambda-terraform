
interface Props {
  message: string;
}
interface Message {
  message: string;
}
const main = (props: Props): Message => {
  const message = `MESSAGE: ${props.message}`;
  console.log(message);
  return { message };
}

export default main;
