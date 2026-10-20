<div align="center">

# 🔥 Hakeem Stego — أداة تلغيم الصور وإخفاء البيانات وتحليل الميتاداتا

### 👑 المطوّر: حكيم العرب — Hakeem Al-Arab
### 🌐 GitHub: [hakim738-html](https://github.com/hakim738-html)
### 🎯 الإصدار: v6.0
### 💻 المنصّة: Termux (Android) • Linux

</div>

---

## 📑 المحتويات
1. [وصف الأداة (عربي)](#-وصف-الأداة-عربي)
2. [About the Tool (English)](#-about-the-tool-english)
3. [شرح آلية العمل](#-شرح-آلية-العمل)
4. [المميزات](#-المميزات)
5. [أوامر التثبيت والتشغيل](#-أوامر-التثبيت-والتشغيل)
6. [أمثلة الاستخدام](#-أمثلة-الاستخدام)
7. [الأسئلة الشائعة](#-الأسئلة-الشائعة)
8. [تنبيهات وإخلاء مسؤولية](#-تنبيهات-وإخلاء-مسؤولية)
9. [الترخيص والتواصل](#-الترخيص-والتواصل)

---

## 📝 وصف الأداة (عربي)

**Hakeem Stego** هي أداة متكاملة مفتوحة المصدر تعمل على **Termux** و **Linux**، تجمع بين وظيفتين قويتين في أداة واحدة:

1. **تلغيم الصور (Steganography):** إخفاء نصوص أو ملفات كاملة داخل صور عادية (PNG / JPG / WEBP) باستخدام تقنية **LSB (أقل بت دلالة)**، مع خيارات **تشفير AES-256** و**ضغط البيانات** قبل الإخفاء، بحيث لا يلاحظ أحد وجود أي شيء مخفي — تبقى الصورة تبدو طبيعية تماماً بالعين المجردة.

2. **تحليل البيانات الوصفية (EXIF Metadata):** استخراج كل المعلومات المخزّنة داخل الصورة، مثل **الموقع الجغرافي (GPS)، الشركة المصنعة، طراز الهاتف/الكاميرا، تاريخ ووقت الالتقاط، دقة الصورة، والبرنامج المستخدم** — حتى الصور القادمة من واتساب (عند إرسالها كـ "مستند").

الأداة **خفيفة**، **لا تحتاج رووت**، وتعمل بواجهة تفاعلية بسيطة بالعربية والإنجليزية.

---

## 📝 About the Tool (English)

**Hakeem Stego** is an open-source, all-in-one security tool for **Termux** and **Linux**. It combines two powerful functions:

1. **Image Steganography:** Hide secret text or entire files (ZIP, PDF, images) inside regular images (PNG / JPG / WEBP) using **LSB (Least Significant Bit)** encoding, with optional **AES-256 encryption** and **compression** before embedding. The carrier image remains visually identical — undetectable to the naked eye.

2. **EXIF Metadata Analysis:** Extract detailed metadata from any image, including **GPS coordinates, device manufacturer, phone/camera model, capture date and time, image resolution, and editing software** — including WhatsApp images sent as "Document".

**Lightweight**, **root-free**, and comes with an **interactive bilingual interface** (Arabic / English).

---

## ⚙️ شرح آلية العمل

### 1️⃣ كيف تعمل تقنية إخفاء النصوص داخل الصور (LSB Steganography)؟
كل صورة رقمية مكوّنة من **بكسلات (Pixels)**، وكل بكسل يتكوّن من ثلاث قنوات لونية: **الأحمر (R)، الأخضر (G)، الأزرق (B)**. كل قناة يتم تمثيلها برقم بين **0 و 255** (أي 8 بتات).

تقنية **LSB** تعتمد على فكرة ذكية: **تغيير آخر بت (أقل بت دلالة) في كل قناة لونية لا يُحدث فرقاً ملحوظاً للعين البشرية**، لكنه يسمح بتخزين بت واحد من البيانات السرية في كل قناة.

**مثال توضيحي:**
