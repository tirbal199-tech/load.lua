import { initializeApp } from "https://www.gstatic.com/firebasejs/9.15.0/firebase-app.js";
import { getDatabase, ref, get, child } from "https://www.gstatic.com/firebasejs/9.15.0/firebase-database.js";

// لا تعدل شيئاً هنا، الرابط صحيح ومربوط ببياناتك
const firebaseConfig = {
  databaseURL: "https://gt6-system-default-rtdb.firebaseio.com/"
};

const app = initializeApp(firebaseConfig);
const db = getDatabase(app);

// الوظيفة التي تجلب البيانات
async function executeAiMatrix() {
    const playerId = document.getElementById('playerId').value;
    const resultBox = document.getElementById('resultBox');
    
    if (!playerId) {
        alert("يرجى إدخال ID اللاعب!");
        return;
    }

    resultBox.style.display = "block";
    resultBox.innerHTML = "جاري الاتصال بالسيرفر...";

    try {
        const dbRef = ref(db);
        const snapshot = await get(child(dbRef, `players/${playerId}`));
        
        if (snapshot.exists()) {
            const data = snapshot.val();
            resultBox.innerHTML = `
                <h3>بيانات اللاعب:</h3>
                <p>الاسم: ${data.name}</p>
                <p>الحالة: ${data.status}</p>
            `;
        } else {
            resultBox.innerHTML = "<p style='color:red;'>خطأ: الـ ID غير موجود!</p>";
        }
    } catch (error) {
        resultBox.innerHTML = "<p style='color:red;'>خطأ في الاتصال بالسيرفر.</p>";
    }
}

// هذا الجزء هو المسؤول عن تشغيل الكود عند الضغط على الزر (بدل الـ onclick)
document.addEventListener('DOMContentLoaded', () => {
    const injectBtn = document.getElementById('injectBtn');
    if (injectBtn) {
        injectBtn.addEventListener('click', executeAiMatrix);
    }
});
