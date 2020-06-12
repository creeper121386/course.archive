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
int w1[23][0];
string s;

struct MyStruct
{
    int member1;
    string member2;
} mystruct;

char char_func(int param1, int param2)
{
    float local1;
    printf("I am a lovely function~ qwq");
    return param1 + param2;
}

struct MyStruct s_func(int param1, int param2)
{
    char local2;
    return param1 + param2;
}

int main()
{
    int array2[3] = [ 2, 3, 3 ];
    int array2d[2][2] = [ [ 1, 2 ], [ 3, 4 ] ];
    int array3[2][0];
    int i = 0;
    struct MyStruct ms[3];
    // declaration at the beginning of code block.

    string s = "wow! you can assign string directly!";
    s = "now I have new value.";

    if (array2[2] == 666){
        i = 0;
    }

    array2[2] = 233;
    mystruct.member1 = 0;
    mystruct.member2 = "ohhhhhhhhh!!!!!!";

    while (1)
    {
        int i = 1;
        i++;
        i += 1;
        i *= 1;
        i /= 1;
        i %= 1;

        if (array2[2] == 666)
        {
            int local3;
            break;
        }
        else if (i == 233)
            continue;
        else
            write("running...");
    }

    for (i = 0; i < 233; i++)
    {
        // do nothing
        int local4;
        read("213");
    }

    switch (i)
    {
    case 0:
        // int local4;
        i++;
        break;
    case 1:
        i++;
        break;
    default:
        // printf("default case!");
        break;
    }

    return 1;
}