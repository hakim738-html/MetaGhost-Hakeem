<div align="center">

# 🔥 Hakeem Stego

### أداة تلغيم الصور وإخفاء البيانات وتحليل الميتاداتا
### Image Steganography & Metadata Forensics Tool

### 👑 المطوّر: حكيم العرب — Hakeem Al-Arab
### 🌐 GitHub: [hakim738-html](https://github.com/hakim738-html)
### 🎯 الإصدار: v6.2 • 💻 Termux (Android) • Linux

<br>

[![🇸🇦 العربية](https://img.shields.io/badge/🇸🇦-العربية-2E8B57?style=for-the-badge&labelColor=000000)](#-النسخة-العربية)
[![🇬🇧 English](https://img.shields.io/badge/🇬🇧-English-1E90FF?style=for-the-badge&labelColor=000000)](#-english-version)
[![📥 Install](https://img.shields.io/badge/📥-التثبيت%20%2F%20Install-FF6B00?style=for-the-badge&labelColor=000000)](#-التثبيت-والتشغيل--install--run)

<br>

[![Version](https://img.shields.io/badge/version-6.2-blue?style=flat-square)](https://github.com/hakim738-html/MetaGhost-Hakeem)
[![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-Termux%20%7C%20Linux-orange?style=flat-square)]()
[![Language](https://img.shields.io/badge/lang-AR%20%7C%20EN-purple?style=flat-square)]()

</div>

---

<a id="-التثبيت-والتشغيل--install--run"></a>
## ⚡ التثبيت والتشغيل السريع — Quick Install & Run

### 🐧 التثبيت (Termux / Linux) — أمر واحد:
```bash
pkg update -y && pkg install -y git python exiftool file binutils findutils coreutils && pip install pillow && termux-setup-storage && cd $HOME && rm -rf MetaGhost-Hakeem 2>/dev/null && git clone https://github.com/hakim738-html/MetaGhost-Hakeem.git && cd MetaGhost-Hakeem && chmod +x install-hakeem-stego.sh hakeem-stego.sh && ./install-hakeem-stego.sh
```

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
> **الشرح:** `pkg update` يحدّث قائمة الحزم المتاحة، و`pkg upgrade` يحدّث الحزم المثبتة إلى أحدث إصدار. `-y` يجيب "نعم" تلقائياً على أي سؤال. **لماذا؟** لضمان توافق الحزم الجديدة مع نظامك.

### 📥 الخطوة 2: تثبيت الأدوات الأساسية
```bash
pkg install -y git python exiftool file binutils findutils coreutils
```
> **الشرح:**
> - `git`: لاستنساخ كود الأداة من GitHub.
> - `python`: لتشغيل وحدة LSB الخاصة بالإخفاء والاستخراج.
> - `exiftool`: الأداة الأقوى لقراءة الميتاداتا (EXIF).
> - `file`: لمعرفة نوع الملف الحقيقي.
> - `binutils`: يوفر أدوات مثل `strings`.
> - `findutils` + `coreutils`: أدوات نظام أساسية.

### 📥 الخطوة 3: تثبيت مكتبة الصور Pillow
```bash
pip install pillow
```
> **الشرح:** Pillow مكتبة Python لمعالجة الصور. تُستخدم لتعديل البكسلات وإخفاء البيانات داخل الصورة. **بدونها لن تعمل تقنية LSB.**

### 📥 الخطوة 4: منح صلاحية التخزين
```bash
termux-setup-storage
```
> **الشرح:** يطلب من نظام أندرويد إذن الوصول إلى `/sdcard` (تخزين الهاتف). **سيظهر تنبيه — اضغط "السماح"**. بدون هذه الخطوة لن تستطيع الأداة قراءة صورك من مجلد DCIM.

### 📥 الخطوة 5: استنساخ الأداة
```bash
cd $HOME && rm -rf MetaGhost-Hakeem 2>/dev/null
git clone https://github.com/hakim738-html/MetaGhost-Hakeem.git
cd MetaGhost-Hakeem
```
> **الشرح:**
> - `cd $HOME`: الانتقال إلى مجلد المستخدم الرئيسي.
> - `rm -rf MetaGhost-Hakeem`: حذف أي نسخة قديمة (لتجنب التعارض). `2>/dev/null` يمنع رسالة الخطأ إن لم تكن النسخة موجودة.
> - `git clone`: تحميل نسخة جديدة من المستودع.
> - `cd MetaGhost-Hakeem`: الدخول إلى مجلد الأداة.

### 📥 الخطوة 6: منح صلاحية التنفيذ
```bash
chmod +x install-hakeem-stego.sh hakeem-stego.sh
```
> **الشرح:** `chmod +x` يجعل الملفين **قابلين للتنفيذ**. بدونه سترى خطأ `Permission denied` عند محاولة تشغيلهما.

### 📥 الخطوة 7: تشغيل المثبّت
```bash
./install-hakeem-stego.sh
```
> **الشرح:** يشغّل سكربت التثبيت الذي يفحص الأدوات، ينشئ المجلدات (`~/Hakeem-Stego`)، ويختبر أن كل شيء جاهز. **مرة واحدة فقط**.

### ▶️ الخطوة 8: تشغيل الأداة
```bash
./hakeem-stego.sh
```
> **الشرح:** يشغّل الواجهة التفاعلية. من القائمة تختار: إخفاء نص، استخراج نص، تحليل EXIF، تحليل جنائي، أو تغيير اللغة. **في كل مرة تريد استخدام الأداة، نفّذ هذا الأمر.**

### 🌍 اختياري: تغيير اللغة
```bash
printf 'en' > ~/.hakeem_lang   # إلى الإنجليزية
printf 'ar' > ~/.hakeem_lang   # إلى العربية
```
> **الشرح:** يكتب حرفَي اللغة في ملف الإعدادات `~/.hakeem_lang`. عند التشغيل التالي ستُقرأ تلقائياً. **ملاحظة:** `printf` أفضل من `echo` لأنه **لا يضيف سطراً جديداً**، وهذا ما كان يسبب مشكلة الإنجليزية سابقاً.

### 🔄 اختياري: تثبيت سريع بدون تحديث
```bash
./install-hakeem-stego.sh --no-update
```
> **الشرح:** يتخطى خطوة `pkg update` لتسريع التثبيت (يفيد إذا كنت واثقاً أن نظامك محدّث).

### 🧹 اختياري: إعادة تثبيت نظيفة
```bash
rm -rf ~/MetaGhost-Hakeem ~/Hakeem-Stego ~/.hakeem_lang
```
> **الشرح:** يحذف المجلدات الثلاثة: كود الأداة، مجلد العمل، وملف اللغة. ثم أعد الخطوات من 5 إلى 8.

### ✅ التحقق من نجاح التثبيت
```bash
which exiftool python3 file
python3 -c "from PIL import Image; print('Pillow OK')"
```
> **المتوقع:**
> ```
> /data/data/com.termux/files/usr/bin/exiftool
> /data/data/com.termux/files/usr/bin/python3
> /data/data/com.termux/files/usr/bin/file
> Pillow OK
> ```

### 🐞 إصلاح مشكلة "الإنجليزية لا تظهر"
```bash
rm -f ~/.hakeem_lang
printf 'en' > ~/.hakeem_lang
cat ~/.hakeem_lang
```
> **الشرح:** إن كانت اللغة عالقة على العربية رغم اختيارك English، فسبب ذلك أن الملف يحتوي سطراً جديداً (`en\n`) يجعل المقارنة تفشل. الحل: احذفه واكتبه نظيفاً. **تم إصلاحه جذرياً في v6.2** عبر `tr -d '[:space:]'` داخل السكربت نفسه.

---

## 🧪 أمثلة عملية

| السيناريو | الخطوات |
|---|---|
| **إخفاء رسالة** | القائمة → [1] → مسار الصورة → النص → اسم المخرج |
| **استخراج رسالة** | القائمة → [2] → مسار الصورة الملغّمة |
| **تحليل صورة** | القائمة → [3] → مسار الصورة → تظهر GPS والطراز والتاريخ |
| **تحليل جنائي** | القائمة → [4] → مسار الصورة → تقرير كامل في `~/Hakeem-Stego/reports/` |

---

## ❓ أسئلة شائعة

**هل تعمل على أندرويد فقط؟**
> لا، تعمل على Linux أيضاً (Ubuntu/Debian) بتعديل بسيط: استبدل `pkg` بـ `apt`.

**هل أحتاج إنترنت؟**
> فقط للتثبيت الأول. بعدها تعمل offline بالكامل.

**هل الصورة تفقد جودتها؟**
> لا. LSB يغيّر بتاً واحداً في كل قناة لونية — فرق غير مرئي. لكن **الإخراج يجب أن يكون PNG** (JPG يعيد الضغط ويُفسد البتات).

**ما أقصى حجم يمكن إخفاؤه؟**
> ~10% من حجم الصورة. صورة 1MB تخفي ~100KB.

**هل يمكن استعادة صورة أصلية بعد التلغيم؟**
> نعم، الأداة تحفظ نسخة احتياطية تلقائياً في `~/Hakeem-Stego/backups/`.

---

<div align="center">
<a href="#-english-version">⬆️ الانتقال إلى الإنجليزية — Go to English</a>
</div>

---

<a id="-english-version"></a>
# 🇬🇧 English Version

## 📝 What Is Hakeem Stego? What Does It Do?

**Hakeem Stego** is an all-in-one, open-source security tool for **Termux** (Android) and **Linux**, built to do two powerful things:

### 🖼️ Function 1: Image Steganography
Hide **secret text** or **entire files** (ZIP, PDF, images) inside a normal-looking image (PNG / JPG / WEBP) using **LSB (Least Significant Bit)** encoding — meaning it flips the last bit of each pixel, which is **invisible to the human eye**. The result: an image that looks 100% normal but secretly carries hidden data.

**You can:**
- Hide a message inside a photo and send it as if it were a regular picture.
- Hide a full PDF or ZIP inside a cover image.
- Protect the hidden data with a password (AES-256 encryption).
- Extract the hidden data later from the image.

### 🔍 Function 2: EXIF Metadata Forensics
Extract **everything stored inside an image**, including what you normally can't see:

- 📍 **GPS location** with a direct Google Maps link.
- 📱 **Manufacturer and phone/camera model**.
- 📅 **Capture date and time**.
- 🖼️ **Image resolution and size**.
- 🛠️ **Editing software used**.
- 🧾 **MD5 / SHA1 / SHA256 hashes** to detect tampering.

**When is this useful?**
- Verifying a suspicious image someone sent you.
- Checking whether a WhatsApp image was sent as "Photo" (metadata stripped) or "Document" (full metadata preserved).
- Investigating professional or camera images.

### 🎯 Who is it for?
- **Developers** who want to understand LSB steganography hands-on.
- **Security researchers** doing quick forensic triage.
- **Regular users** who want to protect their privacy by hiding text in images.
- **Students** studying cybersecurity.

### ⚙️ What it does NOT do:
- ❌ It doesn't hack devices or spy on anyone.
- ❌ It can't recover deleted EXIF (technically impossible).
- ❌ It doesn't require root or special privileges.
- ❌ It doesn't send your data to any server — everything is local.

---

## 🚀 Detailed Installation — Every Command Explained

### 📥 Step 1: Update the System
```bash
pkg update -y && pkg upgrade -y
```
> **Explanation:** `pkg update` refreshes the package list, `pkg upgrade` upgrades installed packages. `-y` auto-confirms prompts. **Why?** To ensure new packages are compatible with your system.

### 📥 Step 2: Install Core Tools
```bash
pkg install -y git python exiftool file binutils findutils coreutils
```
> **Explanation:**
> - `git`: to clone the tool's code from GitHub.
> - `python`: runs the LSB module for hiding/extracting.
> - `exiftool`: the most powerful metadata (EXIF) reader.
> - `file`: identifies the true file type.
> - `binutils`: provides tools like `strings`.
> - `findutils` + `coreutils`: essential system utilities.

### 📥 Step 3: Install Pillow (Python image library)
```bash
pip install pillow
```
> **Explanation:** Pillow is Python's image-processing library. It's used to modify pixels and embed data inside the image. **Without it, LSB won't work.**

### 📥 Step 4: Grant Storage Permission
```bash
termux-setup-storage
```
> **Explanation:** Requests Android permission to access `/sdcard` (phone storage). **A popup will appear — tap "Allow"**. Without this, the tool can't read your photos from the DCIM folder.

### 📥 Step 5: Clone the Tool
```bash
cd $HOME && rm -rf MetaGhost-Hakeem 2>/dev/null
git clone https://github.com/hakim738-html/MetaGhost-Hakeem.git
cd MetaGhost-Hakeem
```
> **Explanation:**
> - `cd $HOME`: moves to the user's home directory.
> - `rm -rf MetaGhost-Hakeem`: deletes any old copy (prevents conflicts). `2>/dev/null` silences errors if none exists.
> - `git clone`: downloads a fresh copy from the repository.
> - `cd MetaGhost-Hakeem`: enters the tool's folder.

### 📥 Step 6: Grant Execution Permission
```bash
chmod +x install-hakeem-stego.sh hakeem-stego.sh
```
> **Explanation:** `chmod +x` makes both files **executable**. Without it, you'll get `Permission denied` when trying to run them.

### 📥 Step 7: Run the Installer
```bash
./install-hakeem-stego.sh
```
> **Explanation:** Runs the install script that checks dependencies, creates folders (`~/Hakeem-Stego`), and verifies everything is ready. **Run once only.**

### ▶️ Step 8: Run the Tool
```bash
./hakeem-stego.sh
```
> **Explanation:** Launches the interactive menu. Choose from: hide text, extract text, EXIF analysis, forensic analysis, or change language. **Run this every time you want to use the tool.**

### 🌍 Optional: Change Language
```bash
printf 'en' > ~/.hakeem_lang   # English
printf 'ar' > ~/.hakeem_lang   # Arabic
```
> **Explanation:** Writes the two-letter language code to the config file `~/.hakeem_lang`. Next launch reads it automatically. **Note:** `printf` is better than `echo` because it **doesn't add a trailing newline** — which was the exact cause of the English-language bug before.

### 🔄 Optional: Fast Install (skip update)
```bash
./install-hakeem-stego.sh --no-update
```
> **Explanation:** Skips the `pkg update` step to speed up installation (useful if you're sure your system is up to date).

### 🧹 Optional: Clean Reinstall
```bash
rm -rf ~/MetaGhost-Hakeem ~/Hakeem-Stego ~/.hakeem_lang
```
> **Explanation:** Deletes all three: the tool code, the working folder, and the language file. Then repeat steps 5–8.

### ✅ Verify Installation
```bash
which exiftool python3 file
python3 -c "from PIL import Image; print('Pillow OK')"
```
> **Expected:**
> ```
> /data/data/com.termux/files/usr/bin/exiftool
> /data/data/com.termux/files/usr/bin/python3
> /data/data/com.termux/files/usr/bin/file
> Pillow OK
> ```

### 🐞 Fix "English Not Showing"
```bash
rm -f ~/.hakeem_lang
printf 'en' > ~/.hakeem_lang
cat ~/.hakeem_lang
```
> **Explanation:** If the language stays stuck on Arabic even after choosing English, the file probably contains a trailing newline (`en\n`) that breaks the comparison. Fix: delete and rewrite cleanly. **Permanently fixed in v6.2** via `tr -d '[:space:]'` inside the script itself.

---

## 🧪 Usage Examples

| Scenario | Steps |
|---|---|
| **Hide a message** | Menu → [1] → image path → text → output name |
| **Extract a message** | Menu → [2] → path to stego image |
| **Analyze an image** | Menu → [3] → image path → shows GPS, model, date |
| **Forensic analysis** | Menu → [4] → image path → full report in `~/Hakeem-Stego/reports/` |

---

## ❓ FAQ

**Does it work only on Android?**
> No, it also runs on Linux (Ubuntu/Debian) with a small tweak: replace `pkg` with `apt`.

**Do I need internet?**
> Only for the first install. After that, it runs fully offline.

**Will the image lose quality?**
> No. LSB changes only one bit per color channel — an invisible difference. But **output must be PNG** (JPG recompression corrupts the bits).

**What's the maximum hiding capacity?**
> ~10% of the image size. A 1MB image hides ~100KB.

**Can I recover the original image after hiding data?**
> Yes, the tool automatically backs up the original in `~/Hakeem-Stego/backups/`.

---

<div align="center">
<a href="#-النسخة-العربية">⬆️ العودة إلى العربية — Back to Arabic</a>
</div>

---

## 📜 License & Contact — الترخيص والتواصل

- **License / الترخيص:** MIT — see `LICENSE` / راجع `LICENSE`.
- **Developer / المطوّر:** حكيم العرب (Hakeem Al-Arab).
- **GitHub:** [@hakim738-html](https://github.com/hakim738-html)
- **Contributions:** Issues and Pull Requests welcome / المساهمات مرحّب بها.

<div align="center">

### ⭐ If you like it, give the repo a star — إذا أعجبتك، امنح المستودع نجمة ⭐

**Made with ❤️ by Hakeem Al-Arab — صُنع بـ ❤️ بواسطة حكيم العرب**

</div>
