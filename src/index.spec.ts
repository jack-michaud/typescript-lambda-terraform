
import main from './index';

test('message is processed correctly', () => {
  expect(main({
    message: 'lemon!'
  })).toStrictEqual({
    message: 'MESSAGE: lemon!'
  });
});
