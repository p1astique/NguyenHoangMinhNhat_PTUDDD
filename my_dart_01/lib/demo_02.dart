import 'dart:io';

bool checkPrime(int x)
{
  if (x < 2) return false;
  for (int k = 2; k <= x; k++)
  {
    if (x % k == 0) return false;
  }
  return true;
}

void demo02()
{
  stdout.write("Enter a number: ");
  String? input = stdin.readLineSync();

  if (input != null && input.isNotEmpty)
  {
    print("You entered: $input");
    int number = int.parse(input);
    if (checkPrime(number))
    {
      print("$number is a prime number.");
    }
    else
    {
      print("$number is not a prime number.");
    }
  }
  else
  {
    print("No input provided.");
  }
}