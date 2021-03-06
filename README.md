# Swift TODO
Mobile Programming HW03, TODO via Swift

## Course
_Mobile Programming_ at Computer Engineering Department at Sharif University of Technology, Tehran, Iran

Instructor: **_Mr. Omid Jafari-Nezhad_**

## Students
| Name | Student Number |
| :-: | :-: |
| _**[Aryan Ahadinia](https://github.com/AryanAhadinia)**_ | _98103878_ |
| _**[Mohammad Hossein Kashani Jabbari](https://github.com/MohammadKashaniJabbari)**_ | _98105987_ |
| _**[Shahab Hosseini Moghaddam](https://github.com/shahab-hm)**_ | _98105716_ |

## How to run
```
set SWIFTFLAGS=-sdk %SDKROOT% -resource-dir %SDKROOT%\usr\lib\swift -I %SDKROOT%\usr\lib\swift -L %SDKROOT%\usr\lib\swift\windows
swiftc %SWIFTFLAGS% -emit-executable -o main.exe main.swift
```

<div dir="rtl">

## نحوه تست کردن پروژه
فایل .exe در مخزن پروژه جهت تست هر چه راحت تر قرار داده شده است.
برای کامپایل کردن در محیط ویندوز میتوانید از بخش How to run دستورالعمل هایی که باید در cmd وارد شوند را مشاهده کنید.

### ساختار کلی
به صورت کلی ساختار منوهای این برنامه به صورت درختی است و در هر منو کار با وارد کردن شماره زیر منو مورد نظر، به زیر منو بعدی منتقل میشوید.
توجه کنید که دستور العمل صفر در همه منوها کاربرد back را دارد و در منوی اصلی برای exit به کار میرود. 

### ساختن todo جدید
<div dir="ltr">

    > 1. My tasks 
    > 1. Create a new task
    Please enter title:
    Please enter content:
    Please enter priority:    
</div>

برای این کار در منوی برنامه ابتدا گزینه my tasks را با عدد 1 و سپس گزینه create a new task را با عدد 1 انتخاب میکنیم.
سپس برنامه از شما نام و محتوا و اولویت تسک را میخواهد که آنها را وارد میکنید.
تسک به این ترتیب ساخته میشود.

### امکان دیدن تمام todo ها در یک لیست
<div dir="ltr">

    > 1. My tasks
    [a list of tasks will show here]
</div>

برای این کار کافیست در منوی اصلی برنامه به صفحه my tasks بروید.
هر گاه این صفحه را باز کنید لیستی از تسک ها به شما نمایش داده میشود.
البته میتوانید به زیر منوی show all tasks هم مراجعه کنید که جلوتر در بخش sort کردن توضیح داده میشود.
  
### امکان ویرایش todo
<div dir="ltr">

    > 1. My tasks
    > 2. Edit a tasks
    [a list of tasks will show here]
    Please enter index of task you want to edit (0 to escape):
    Please enter title (enter to escape): 
    Please enter content (enter to escape): 
    Please enter priority (enter to escape): 
</div>

در منوی my tasks به زیر منوی 2 یعنی edit a task وارد شوید.
در آنجا تسک ها به شما نشان داده خواهد شد و شما با وارد کردن شماره گزینه تسک میتوانید یکی را انتخاب و آن را ویرایش کنید.
همچنین با ورود عدد 0 میتوانید انصراف دهید.

وقتی که تسک مورد نظر برای ویرایش را انتخاب کردید میتوانید هر یک از سه ویژگی را ادیت کنید.
ابتدا از شما خواسته میشود که title را ادیت کنید؛ اگر قصد ادیت title را ندارید کافیت enter را بزنید.
سپس از شما خواسته میشود که contnet و سپس priority را ویرایش کنید. در هر یک از دو مورد میتوانید با زدن دکمه اینتر آن بخش را دست نخورده باقی بگذارید.

### امکان حذف آیتم
<div dir="ltr">

    > 1. My tasks
    > 3. Delete a task
    [a list of tasks will show here]
    Please enter index of task you want to delete (0 to escape):
</div>

برای حذف کردن آیتم در منوی my tasks میتوانید با انتخاب گزینه 3 یعنی delete a task یک تسک را پاک کنید.
به این صورت که تسک ها به شما نمایش داده میشوند و عدد جلوی هر کدام را که وارد کنید آن را پاک میکند.
در این بخش هم میتوانید با ورود عدد 0 صرف نظر کنید.

### امکان sort کردن
<div dir="ltr">

    > 1. My tasks
    > 4. Show all tasks
    1. Sorted by title
    2. Sorted by priority
    3. Sorted by creation date
    How do you want to sort tasks?
    1. Ascending
    2. Descending
    In which direction?
</div>

برای این کار کافیست در منوی My tasks گزینه 4 یعنی show all tasks را انتخاب کنید.
با این کار به شما 3 گزینه نمایش داده میشود که به ترتیب از 1 تا 3 مرتب سازی را بر اساس title و یا اولویت و یا تاریخ ایجاد انجام میدهند.
سپس با انتخاب یکی از کزینه های 1 یا 2 یعنی ascending یا descending میتوانید مرتب سازی را به صورت صعودی یا نزولی بر همان پایه ای که مشخص کرده اید انجام دهید.

### امکان ایجاد دسته با نام یکتا
<div dir="ltr">

    > 2. Manage categories
    > 2. Create a new category
    Please enter name:
</div>

برای این کار در منوی اصلی برنامه به منوی 2 یعنی manage categories وارد شوید.
در این منو با ورود عدد 2 به بخش ایجاد category وارد میشوید.
در این زیر منو با ورود نام دسته بندی، برنامه آن را میسازد.
اگر نام تکراری بود خطا نشان داده میشود و باید نام دیگری انتخاب کنید.

بعد از ساخته شدن دسته بندی، نام تمام دسته ها با تعداد تسک هایشان چاپ میشود که از آنجا میتوانید مطمئن شوید دسته بندی ساخته شده.

### امکان اضافه کردن یک یا چند آیتم به دسته بندی
<div dir="ltr">

    > 2. Manage categories
    > 3. Add a task to a category
    [a list of tasks will show here]
    Please enter index of the task you want to add to a category:
    [a list of categories will show here]
    Please enter index of the category you want to add to it:
</div>

برای این کار در همان زیر منوی Manage Categories میتوانید با انتخاب گزینه 3 یعنی add a task to a category این کار را انجام دهید.
با ورود به این زیر منو تسک ها به شما نشان داده شده و شماره یک تسک از شما خواسته میشود.
با ورود شماره تسک، تمام دسته بندی ها به شما نمایش داده شده و شماره دسته بندی از شما خواسته میشود.
با ورود این دو عدد یک تسک به یک دسته بندی اضافه میشود.

### امکان مشاده todo های یک دسته خاص
<div dir="ltr">

    > 2. Manage categories
    > 1. Open an specific category
    [a list of categories will show here]
    Please enter index of the category you want to open:
</div>

در همان منوی Manage Categories میتوانید با ورود عدد 1 به زیر منوی این بخش بروید.
تمام دسته بندی ها با یک شماره به شما نمایش داده میشود و شما با ورود شماره یکی از آنها، تمام تسک های آن را میبینید.

</div>
