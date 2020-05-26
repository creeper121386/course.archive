// line comment
/* block comment */

/* 
block comment over multiple lines
*/

int 1a, b, c; // line comment after code
int d = 1;
float e, f;

char g = 'c', h;
int array[10];
string s;

struct MyStruct
{
    int member1;
    string member2;
} mystruct;

int function(int param1, int param2)
{
    printf("I am a lovely function~ qwq");
    return param1 + param2;
}

int main()
{
    int anotherArray = [ 2, 3, 3 ];
    int array2d[2][2] = [ [ 1, 2 ], [ 3, 4 ] ];
    int i = 0;
    // declaration at the beginning of code block.

    string s = "wow! you can assign struct directly!";
    s = "now I have new value.";

    anotherArray[2] = 233;
    mystruct.member1 = 0;
    mystruct.member2 = "ohhhhhhhhh!!!!!!";

    while (1)
    {
        i++;
        i += 1;
        i *= 1;
        i /= 1;
        i %= 1;

        if (i == 666)
            break;
        else if (i == 233)
            continue;
        else
            printf("running...");
    }

    for (i = 0; i < 233; i++)
    {
        // do nothing
    }

    switch (i)
    {
    case 0:
        i++;
        break;
    case 1:
        i++;
        break;
    default:
        printf("default case!");
        break;
    }

    return 1;
}