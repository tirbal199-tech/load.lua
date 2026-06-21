// استيراد مكتبات Firebase (يتم من خلال الرابط مباشرة)
import { initializeApp } from "https://www.gstatic.com/firebasejs/9.15.0/firebase-app.js";
import { getDatabase, ref, get, child } from "https://www.gstatic.com/firebasejs/9.15.0/firebase-database.js";

// إعدادات الاتصال بالسيرفر الخاص بك
const firebaseConfig = {
  databaseURL: "https://gt6-system-default-rtdb.firebaseio.com/"
};

// تهيئة الاتصال
const app = initializeApp(firebaseConfig);
const db = getDatabase(app);

// الوظيفة التي تتصل فعلياً بالسيرفر عند الضغط على الزر
window.executeAiMatrix = async function() {
    let playerId = document.getElementById('playerId').value;
    let resultBox = document.getElementById('resultBox');
    
    if (!playerId) {
        alert("يرجى إدخال ID اللاعب!");
        return;
    }

    resultBox.innerHTML = "[..] جاري التحقق من قاعدة البيانات...";

    try {
        const dbRef = ref(db);
        const snapshot = await get(child(dbRef, `players/${playerId}`));
        
        if (snapshot.exists()) {
            const data = snapshot.val();
            resultBox.innerHTML = `
                <h3 style="color: #00ff00;">[✓] بيانات اللاعب موجودة</h3>
                <p>الاسم: ${data.name}</p>
                <p>الحالة: ${data.status}</p>
            `;
        } else {
            resultBox.innerHTML = "<p style='color: red;'>[!] اللاعب غير موجود في قاعدة البيانات.</p>";
        }
    } catch (error) {
        resultBox.innerHTML = "<p style='color: red;'>[!] خطأ في الاتصال بالسيرفر.</p>";
        console.error(error);
    }
};
