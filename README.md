<div align="center">

# 🔥 Hakeem Stego

### أداة تلغيم الصور وإخفاء البيانات وتحليل الميتاداتا
### Image Steganography & Metadata Forensics Tool

### 👑 المطوّر: حكيم العرب — Hakeem Al-Arab
### 🌐 GitHub: [hakim738-html](https://github.com/hakim738-html)
### 🎯 الإصدار: v6.3 • 💻 Termux (Android) • Linux

<br>

[![🇸🇦 العربية](https://img.shields.io/badge/🇸🇦-العربية-2E8B57?style=for-the-badge&labelColor=000000)](#-النسخة-العربية)
[![🇬🇧 English](https://img.shields.io/badge/🇬🇧-English-1E90FF?style=for-the-badge&labelColor=000000)](#-english-version)
[![📥 Install](https://img.shields.io/badge/📥-التثبيت%20%2F%20Install-FF6B00?style=for-the-badge&labelColor=000000)](#-التثبيت-والتشغيل--install--run)

<br>

[![Version](https://img.shields.io/badge/version-6.3-blue?style=flat-square)](https://github.com/hakim738-html/MetaGhost-Hakeem)
[![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Termux%20%7C%20Linux-orange?style=flat-square)]()
[![Language](https://img.shields.io/badge/lang-AR%20%7C%20EN-purple?style=flat-square)]()

</div>

---

<a id="-التثبيت-والتشغيل--install--run"></a>
## ⚡ التثبيت والتشغيل السريع — Quick Install & Run

### 🐧 التثبيت (Termux) — أمر واحد مُصحّح:
```bash
pkg update -y && pkg install -y git python python-pillow exiftool file binutils findutils coreutils && termux-setup-storage && cd $HOME && rm -rf MetaGhost-Hakeem 2>/dev/null && git clone https://github.com/hakim738-html/MetaGhost-Hakeem.git && cd MetaGhost-Hakeem && chmod +x install-hakeem-stego.sh hakeem-stego.sh && ./install-hakeem-stego.sh
```

> ✅ **تم استبدال `pip install pillow` بـ `pkg install python-pillow`** — لأن Pillow لا يوفر wheels جاهزة لـ android-24-arm64 مع Python 3.14، فيفشل البناء من المصدر بسبب نقص `libjpeg`. حزمة Termux الرسمية تحل المشكلة فوراً.

### ▶️ التشغيل:
```bash
cd ~/MetaGhost-Hakeem && ./hakeem-stego.sh
```

### 🌍 تبديل اللغة / Switch Language:
```bash
printf 'en' > ~/.hakeem_lang   # English
printf 'ar' > ~/.hakeem_lang   # العربية
```

---

<a id="-النسخة-العربية"></a>
# 🇸🇦 النسخة العربية

## 📝 ما هي أداة Hakeem Stego؟ وماذا تفعل؟

**Hakeem Stego** أداة أمنية متكاملة، مفتوحة المصدر، تعمل على **Termux** (أندرويد) و**Linux**، وتُنجز مهمتين قويتين في أداة واحدة:

### 🖼️ المهمة الأولى: تلغيم الصور (Image Steganography)
تخفي **نصوصاً سرية** أو **ملفات كاملة** (ZIP، PDF، صور) داخل صورة عادية (PNG / JPG / WEBP) باستخدام تقنية **LSB (Least Significant Bit)** — أي تعديل آخر بت في كل بكسل، وهو تعديل **لا تراه العين البشرية**. النتيجة: صورة تبدو طبيعية 100% لكنها تحتوي بيانات خفية لا يعرف بها أحد.

**ما يمكنك فعله بها:**
- إخفاء رسالة نصية داخل صورة وإرسالها كأنها صورة عادية.
- إخفاء ملف PDF أو ZIP كامل داخل صورة غلاف.
- حماية المحتوى المخفي بكلمة مرور (تشفير AES-256).
- استخراج البيانات المخفية لاحقاً من الصورة.

### 🔍 المهمة الثانية: التحليل الجنائي للميتاداتا (EXIF Forensics)
تستخرج **كل المعلومات المخزّنة داخل الصورة**، بما فيها ما لا تراه عادةً عند فتحها:

- 📍 **الموقع الجغرافي (GPS)** مع رابط مباشر لخرائط جوجل.
- 📱 **الشركة المصنعة وطراز الهاتف/الكاميرا**.
- 📅 **تاريخ ووقت التقاط الصورة**.
- 🖼️ **دقة الصورة وحجمها**.
- 🛠️ **البرنامج المستخدم** في تعديلها.
- 🧾 **تجزئات MD5 / SHA1 / SHA256** للتحقق من التلاعب.

**متى تكون مفيدة؟**
- التحقق من صورة مشبوهة وصلتك.
- معرفة إن كانت صورة واتساب أُرسلت كـ "صورة" (بيانات محذوفة) أو "مستند" (بيانات كاملة).
- التحقيق في صور احترافية أو صور من كاميرات.

### 🎯 لمن هذه الأداة؟
- **المطوّرون** الذين يريدون فهم تقنية LSB عملياً.
- **الباحثون الأمنيون** الذين يجرون تحليلات أولية.
- **المستخدم العادي** الذي يريد حماية خصوصيته بإخفاء نصوص داخل صور.
- **الطلاب** الذين يدرسون الأمن السيبراني.

### ⚙️ ما لا تفعله الأداة:
- ❌ لا تخترق الأجهزة ولا تتجسس على أحد.
- ❌ لا تستعيد بيانات EXIF محذوفة (مستحيل تقنياً).
- ❌ لا تحتاج رووت ولا صلاحيات خارقة.
- ❌ لا ترسل بياناتك لأي خادم — كل شيء محلي.

---

## 🚨 حل مشكلة تثبيت Pillow (مهم!)

### ❌ المشكلة:
```
ERROR: Failed building wheel for pillow
RequiredDependencyException: jpeg
The headers or library files could not be found for jpeg
```

**السبب:** `pip install pillow` لا يجد wheels جاهزة لـ `android-24-arm64` مع Python 3.14، فيحاول البناء من المصدر ويفشل لعدم وجود `libjpeg`.

### ✅ الحل النهائي:
```bash
pkg install -y python-pillow
python3 -c "from PIL import Image; print('✅ Pillow OK:', Image.__version__)"
```

### 🔧 إذا استمر الفشل (خطة بديلة):
```bash
# 1. ثبت مكتبات التطوير
pkg install -y libjpeg-turbo libpng zlib libtiff libwebp

# 2. ثبت Pillow
pkg install -y python-pillow

# 3. تحقق
python3 -c "from PIL import Image; print('OK')"
```

### 📊 مقارنة سريعة:

| الطريقة | النتيجة | الوقت |
|---|---|---|
| `pip install pillow` | ❌ فشل | — |
| `pip install pillow` + libjpeg | ⚠️ قد ينجح | 10-15 دقيقة |
| **`pkg install python-pillow`** | ✅ **نجاح فوري** | **10 ثوانٍ** |

---

## 🚀 التثبيت المفصّل — كل أمر مع شرحه

### 📥 الخطوة 1: تحديث النظام
```bash
pkg update -y && pkg upgrade -y
```
> **الشرح:** يحدّث قائمة الحزم والحزم المثبتة. `-y` يجيب "نعم" تلقائياً.

### 📥 الخطوة 2: تثبيت الأدوات الأساسية + Pillow
```bash
pkg install -y git python python-pillow exiftool file binutils findutils coreutils
```
> **الشرح:**
> - `git`: استنساخ الكود من GitHub.
> - `python`: لتشغيل وحدة LSB.
> - **`python-pillow`**: مكتبة الصور — **حزمة Termux الرسمية** (بدل pip).
> - `exiftool`: لقراءة الميتاداتا.
> - `file`, `binutils`, `findutils`, `coreutils`: أدوات مساعدة.

### 📥 الخطوة 3: التحقق من Pillow
```bash
python3 -c "from PIL import Image; print('Pillow version:', Image.__version__)"
```
> **المتوقع:** `Pillow version: 11.x.x` أو أعلى.

### 📥 الخطوة 4: منح صلاحية التخزين
```bash
termux-setup-storage
```
> **الشرح:** يطلب إذن الوصول إلى `/sdcard`. اضغط "السماح".

### 📥 الخطوة 5: استنساخ الأداة
```bash
cd $HOME && rm -rf MetaGhost-Hakeem 2>/dev/null
git clone https://github.com/hakim738-html/MetaGhost-Hakeem.git
cd MetaGhost-Hakeem
```

### 📥 الخطوة 6: منح صلاحية التنفيذ
```bash
chmod +x install-hakeem-stego.sh hakeem-stego.sh
```

### 📥 الخطوة 7: تشغيل المثبّت
```bash
./install-hakeem-stego.sh
```

### ▶️ الخطوة 8: تشغيل الأداة
```bash
./hakeem-stego.sh
```

---

## 🐧 للمستخدمين على Linux (Ubuntu/Debian)

الأمر السابق يستخدم `pkg` (خاص بـ Termux). على Linux استبدله بـ `apt`:

```bash
# 1. المتطلبات
sudo apt update
sudo apt install -y git python3 python3-pil python3-pil.imagetk libimage-exiftool-perl file binutils findutils coreutils

# 2. استنساخ
cd $HOME && git clone https://github.com/hakim738-html/MetaGhost-Hakeem.git
cd MetaGhost-Hakeem && chmod +x *.sh

# 3. التثبيت والتشغيل
./install-hakeem-stego.sh
./hakeem-stego.sh
```

> **ملاحظة:** على Linux، Pillow متوفر كـ `python3-pil` من apt — أسرع وأكثر استقراراً من pip.

---

## 🌍 تبديل اللغة — Language Switch

### الطريقة 1: من داخل الأداة
```
القائمة → [6] تغيير اللغة → اختر 1 أو 2
```

### الطريقة 2: بأمر مباشر
```bash
# إلى الإنجليزية
printf 'en' > ~/.hakeem_lang

# إلى العربية
printf 'ar' > ~/.hakeem_lang
```

### 🐞 إصلاح مشكلة "الإنجليزية لا تظهر"
```bash
rm -f ~/.hakeem_lang
printf 'en' > ~/.hakeem_lang
cat ~/.hakeem_lang    # يجب أن يطبع: en (بدون سطر فارغ)
./hakeem-stego.sh
```
> **السبب:** الملف القديم قد يحتوي `en\n` (سطر جديد) فيفشل شرط المقارنة. **تم إصلاحه جذرياً في v6.3** عبر `tr -d '[:space:]'` داخل السكربت.

---

## ✅ التحقق من نجاح التثبيت

```bash
# فحص الأدوات
which git python3 exiftool file
# المتوقع: مسارات /data/data/com.termux/files/usr/bin/...

# فحص Pillow
python3 -c "from PIL import Image; print('Pillow OK:', Image.__version__)"
# المتوقع: Pillow OK: 11.x.x

# فحص إصدار exiftool
exiftool -ver
# المتوقع: 13.xx

# فحص المجلدات
ls -la ~/Hakeem-Stego/
# المتوقع: stego-images, reports, backups, logs, hidden-files
```

---

## 🧪 أمثلة عملية

| السيناريو | الخطوات |
|---|---|
| **إخفاء رسالة** | القائمة → [1] → مسار الصورة → النص → اسم المخرج |
| **استخراج رسالة** | القائمة → [2] → مسار الصورة الملغّمة |
| **تحليل صورة** | القائمة → [3] → مسار الصورة → يظهر GPS والطراز والتاريخ + تقرير HTML في Downloads |
| **تحليل جنائي** | القائمة → [4] → مسار الصورة → تقرير كامل + HTML |

---

## ❓ أسئلة شائعة

**❓ فشل `pip install pillow` — ماذا أفعل؟**
> استخدم `pkg install python-pillow` بدلاً منه. هذه هي الطريقة الصحيحة على Termux.

**❓ هل تعمل على أندرويد فقط؟**
> لا، تعمل على Linux أيضاً. استبدل `pkg` بـ `apt` واستخدم `python3-pil` بدل `python-pillow`.

**❓ هل الصورة تفقد جودتها؟**
> لا. LSB يغيّر بتاً واحداً في كل قناة لونية. لكن **الإخراج يجب أن يكون PNG**.

**❓ ما أقصى حجم يمكن إخفاؤه؟**
> ~10% من حجم الصورة. صورة 1MB تخفي ~100KB.

**❓ لماذا لا تظهر ميتاداتا واتساب؟**
> واتساب يحذفها عند الإرسال كـ "صورة". اطلب إرسالها كـ **"مستند"**.

**❓ تحذير `No mirror selected` — هل يسبب مشكلة؟**
> لا، مجرد تحذير. لتثبيت مرآة: `termux-change-repo` → اختر Grimler → OK.

---

## 📜 الترخيص والتواصل

- **الترخيص:** MIT — راجع `LICENSE`.
- **المطوّر:** حكيم العرب (Hakeem Al-Arab).
- **GitHub:** [@hakim738-html](https://github.com/hakim738-html)
- **المساهمات:** Issues و Pull Requests مرحّب بها.

<div align="center">

### ⭐ إذا أعجبتك الأداة، امنح المستودع نجمة ⭐
**صُنع بـ ❤️ بواسطة حكيم العرب**

</div>

---

<a id="-english-version"></a>
# 🇬🇧 English Version

## 📝 What Is Hakeem Stego?

**Hakeem Stego** is an open-source security tool for **Termux** and **Linux** with two main functions:

### 🖼️ Image Steganography
Hide secret text or entire files (ZIP, PDF, images) inside PNG/JPG/WEBP images using **LSB (Least Significant Bit)** — an invisible modification to the eye. Optional **AES-256 encryption** and **compression**.

### 🔍 EXIF Metadata Forensics
Extract **GPS location, device make/model, capture date, resolution, editing software, and MD5/SHA hashes** — including WhatsApp images sent as "Document".

---

## 🚨 Pillow Installation Fix (Important!)

### ❌ Problem:
```
ERROR: Failed building wheel for pillow
RequiredDependencyException: jpeg
```

**Cause:** `pip install pillow` has no prebuilt wheel for `android-24-arm64` with Python 3.14, so it tries to compile from source and fails due to missing `libjpeg`.

### ✅ Solution:
```bash
pkg install -y python-pillow
python3 -c "from PIL import Image; print('✅ Pillow OK:', Image.__version__)"
```

### 🐧 On Linux (Ubuntu/Debian):
```bash
sudo apt install -y python3-pil python3-pil.imagetk
```

---

## 🚀 Quick Install (Fixed)

### Termux:
```bash
pkg update -y && pkg install -y git python python-pillow exiftool file binutils findutils coreutils && termux-setup-storage && cd $HOME && rm -rf MetaGhost-Hakeem 2>/dev/null && git clone https://github.com/hakim738-html/MetaGhost-Hakeem.git && cd MetaGhost-Hakeem && chmod +x install-hakeem-stego.sh hakeem-stego.sh && ./install-hakeem-stego.sh
```

### Run:
```bash
cd ~/MetaGhost-Hakeem && ./hakeem-stego.sh
```

---

## ✅ Verify Installation

```bash
which git python3 exiftool file
python3 -c "from PIL import Image; print('Pillow OK:', Image.__version__)"
exiftool -ver
ls -la ~/Hakeem-Stego/
```

---

## 🧪 Usage

| Scenario | Steps |
|---|---|
| **Hide a message** | Menu → [1] → image path → text → output name |
| **Extract a message** | Menu → [2] → stego image path |
| **Analyze EXIF** | Menu → [3] → image path → HTML report in Downloads |
| **Forensic analysis** | Menu → [4] → image path → full report + HTML |

---

## ❓ FAQ

**❓ `pip install pillow` failed — what to do?**
> Use `pkg install python-pillow` instead. This is the correct way on Termux.

**❓ Linux compatibility?**
> Yes. Replace `pkg` with `apt` and use `python3-pil` instead of `python-pillow`.

**❓ Loss of image quality?**
> No. LSB changes only one bit per channel. Output must be PNG.

**❓ Max hiding capacity?**
> ~10% of image size.

---

## 📜 License & Contact

- **License:** MIT — see `LICENSE`.
- **Developer:** Hakeem Al-Arab.
- **GitHub:** [@hakim738-html](https://github.com/hakim738-html)

<div align="center">

### ⭐ If you like it, give the repo a star ⭐
**Made with ❤️ by Hakeem Al-Arab**

</div>
