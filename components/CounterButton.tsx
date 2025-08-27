'use client'; // このファイルがクライアントコンポーネントであることを宣言

import { useState } from 'react';

export default function CounterButton() {
  const [count, setCount] = useState(0);

  return (
    <button
      onClick={() => setCount(count + 1)}
      className="mt-4 rounded-lg bg-blue-500 px-4 py-2 text-white"
    >
      クリックされた回数: {count}
    </button>
  );
}