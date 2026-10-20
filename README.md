<div align="center">

# 🔥 Hakeem Stego

### أداة تلغيم الصور وإخفاء البيانات وتحليل الميتاداتا
### Image Steganography & Metadata Forensics Tool

### 👑 المطوّر: حكيم العرب — Hakeem Al-Arab
### 🌐 GitHub: [hakim738-html](https://github.com/hakim738-html)
### 🎯 الإصدار: v6.4 • 💻 Termux (Android) • Linux

<br>

[![🇸🇦 العربية](https://img.shields.io/badge/🇸🇦-العربية-2E8B57?style=for-the-badge&labelColor=000000)](#-النسخة-العربية)
[![🇬🇧 English](https://img.shields.io/badge/🇬🇧-English-1E90FF?style=for-the-badge&labelColor=000000)](#-english-version)
[![📥 Install](https://img.shields.io/badge/📥-التثبيت%20%2F%20Install-FF6B00?style=for-the-badge&labelColor=000000)](#-التثبيت-والتشغيل--install--run)

<br>

[![Version](https://img.shields.io/badge/version-6.4-blue?style=flat-square)](https://github.com/hakim738-html/MetaGhost-Hakeem)
[![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Termux%20%7C%20Linux-orange?style=flat-square)]()
[![Language](https://img.shields.io/badge/lang-AR%20%7C%20EN-purple?style=flat-square)]()

</div>

---

<a id="-التثبيت-والتشغيل--install--run"></a>
## ⚡ التثبيت والتشغيل السريع — Quick Install & Run

### 🐧 التثبيت (Termux) — أمر واحد شامل:
```bash
pkg update -y && pkg install -y git python python-pillow exiftool file binutils findutils coreutils && pip install arabic-reshaper python-bidi --break-system-packages && termux-setup-storage && cd $HOME && rm -rf MetaGhost-Hakeem 2>/dev/null && git clone https://github.com/hakim738-html/MetaGhost-Hakeem.git && cd MetaGhost-Hakeem && chmod +x install-hakeem-stego.sh hakeem-stego.sh && ./install-hakeem-stego.sh
```

> ✅ **تمت إضافة `pip install arabic-reshaper python-bidi`** — لحل مشكلة الحروف العربية المبعثرة والمقلوبة في طرفية Termux، بحيث تظهر متصلة وبالاتجاه الصحيح (من اليمين لليسار).

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
> - `python-pillow`: مكتبة الصور (بديل مثبت مسبقاً لـ pip).
> - `exiftool`: لقراءة الميتاداتا.
> - `file`, `binutils`, `findutils`, `coreutils`: أدوات مساعدة.

### 📥 الخطوة 3: 🆕 تثبيت مكتبات دعم اللغة العربية
```bash
pip install arabic-reshaper python-bidi --break-system-packages
```
> **الشرح:**
> - `arabic-reshaper`: يربط الحروف العربية ببعضها (م ب ع ث ر ة ← مبعثرة).
> - `python-bidi`: يعكس اتجاه النص ليطبعه من اليمين إلى اليسار (RTL).
> - **بدون هاتين المكتبتين:** ستظهر القوائم العربية في الطرفية مقطّعة ومعكوسة. **لا تؤثر على تقارير HTML** لأن المتصفح يدعم العربية أصلاً.

### 📥 الخطوة 4: منح صلاحية التخزين
```bash
termux-setup-storage
```
> **الشرح:** يطلب إذن الوصول إلى `/sdcard` لقراءة الصور. اضغط "السماح".

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

## 🔤 كيف تحل الأداة مشكلة الحروف العربية؟

| المشكلة | الحل المدمج في الأداة |
|---|---|
| الحروف مقطّعة (`م ب ع ث ر ة`) | مكتبة `arabic-reshaper` تربطها (`مبعثرة`) |
| النص معكوس (`ة ر ث ع ب م`) | مكتبة `python-bidi` تعكس الاتجاه (RTL) |
| الأرقام العربية تُسبب "الملف غير موجود" | الأداة تحوّل `٢٠٢٦` تلقائياً إلى `2026` |
| تقرير التحليل | يُحفظ كـ **HTML** في Downloads (المتصفح يعرض العربية بشكل مثالي 100%) |

---

## 🐧 للمستخدمين على Linux (Ubuntu/Debian)

```bash
# 1. المتطلبات
sudo apt update
sudo apt install -y git python3 python3-pil python3-pip libimage-exiftool-perl file binutils findutils coreutils

# 2. مكتبة اللغة العربية
pip3 install arabic-reshaper python-bidi --break-system-packages

# 3. استنساخ وتشغيل
cd $HOME && git clone https://github.com/hakim738-html/MetaGhost-Hakeem.git
cd MetaGhost-Hakeem && chmod +x *.sh
./install-hakeem-stego.sh
./hakeem-stego.sh
```

---

## ✅ التحقق من نجاح التثبيت

```bash
# 1. الأدوات الأساسية
which git python3 exiftool file

# 2. Pillow
python3 -c "from PIL import Image; print('Pillow OK:', Image.__version__)"

# 3. 🆕 دعم العربية
python3 -c "import arabic_reshaper; from bidi.algorithm import get_display; print('Arabic support OK')"
```

المتوقع:
```
Pillow OK: 11.x.x
Arabic support OK
```

---

## 🧪 أمثلة عملية

| السيناريو | الخطوات |
|---|---|
| **إخفاء رسالة** | القائمة → [1] → مسار الصورة → النص → اسم المخرج |
| **استخراج رسالة** | القائمة → [2] → مسار الصورة الملغّمة |
| **تحليل صورة** | القائمة → [3] → مسار الصورة → تقرير HTML في Downloads |
| **تحليل جنائي** | القائمة → [4] → مسار الصورة → تقرير كامل + HTML |

---

## ❓ أسئلة شائعة

**❓ فشل `pip install pillow` — ماذا أفعل؟**
> استخدم `pkg install python-pillow` بدلاً منه. هذه هي الطريقة الصحيحة على Termux.

**❓ الحروف العربية ما زالت مقطّعة؟**
> تأكد من تثبيت `arabic-reshaper` و `python-bidi` بالأمر: `pip install arabic-reshaper python-bidi --break-system-packages`. وإذا لم تُحل المشكلة، استخدم تقرير HTML (يعرض العربية بشكل مثالي).

**❓ هل تعمل على أندرويد فقط؟**
> لا، تعمل على Linux أيضاً (استبدل `pkg` بـ `apt`).

**❓ لماذا لا تظهر ميتاداتا واتساب؟**
> واتساب يحذفها عند الإرسال كـ "صورة". اطلب إرسالها كـ **"مستند"**.

**❓ ما أقصى حجم يمكن إخفاؤه؟**
> ~10% من حجم الصورة. صورة 1MB تخفي ~100KB.

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

## 🚀 Quick Install (Fixed & Complete)

### Termux:
```bash
pkg update -y && pkg install -y git python python-pillow exiftool file binutils findutils coreutils && pip install arabic-reshaper python-bidi --break-system-packages && termux-setup-storage && cd $HOME && rm -rf MetaGhost-Hakeem 2>/dev/null && git clone https://github.com/hakim738-html/MetaGhost-Hakeem.git && cd MetaGhost-Hakeem && chmod +x install-hakeem-stego.sh hakeem-stego.sh && ./install-hakeem-stego.sh
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
python3 -c "import arabic_reshaper; from bidi.algorithm import get_display; print('Arabic support OK')"
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

**❓ Arabic letters still disconnected?**
> Ensure `arabic-reshaper` and `python-bidi` are installed. If the issue persists, use the HTML report (perfect Arabic display).

**❓ Linux compatibility?**
> Yes. Replace `pkg` with `apt` and use `python3-pil` instead of `python-pillow`.

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
